;;;2.40
(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
	    (map proc (cdr items)))))
(define (filter predicate sequence)
  (cond ((null? sequence) '())
	((predicate (car sequence))
	 (cons (car sequence)
	       (filter predicate (cdr sequence))))
	(else (filter predicate (cdr sequence)))))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) 
	  (accumulate op initial (cdr sequence)))))
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))
(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))
(define (divides? a b) 
  (= (remainder a b) 0))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? n test-divisor) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (prime? n)
  (= (smallest-divisor n) n))
(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))
(define unique-pairs
  (lambda (i)
	 (map (lambda(j) (list i j))
	      (enumerate-interval 1 (- i 1)))))            
(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))
(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
	       (flatmap
		unique-pairs (enumerate-interval 1 n)))))
(prime-sum-pairs 6)
;;;2.41
(define (not-null? pair)
 (not (null? pair)))
(define (find-all-triples s n)
  (filter not-null?
  (flatmap
   (lambda (i)
      (map (lambda (j)
	     (if (and (not (> (- s i j) n)) (> (- s i j) 0)) (list i j (- s i j)) '() ))
	   (enumerate-interval i (min n s))))
    (enumerate-interval 1 (min n s)))))
(find-all-triples 8 10)
;;;2.42
(define empty-board '())
(define (adjoin-position new-row k rest-of-queens)
  (cons (list new-row k) rest-of-queens))
(define (queens-row queen) (car queen))
(define (queens-col queen) (cadr queen))
(define (safe? k positions)
  (define pair (car positions))
  (accumulate (lambda (position flag)
		(and flag
		(not (or  (= (queens-row position) (queens-row pair))
			  (= (abs (- (queens-row position) (queens-row pair)))
			     (abs (- (queens-col position) (queens-col pair))))))))
	      #t
	      (cdr positions)))		        
;;;it's substitue safe? for debugging
(define (test? k positions) (= 1 1))
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
	(list empty-board)
	(filter
	 (lambda (positions) (safe? k positions))
	 (flatmap
	  (lambda (rest-of-queens)
	    (map (lambda (new-row)
		   (adjoin-position new-row k rest-of-queens))
		 (enumerate-interval 1 board-size)))
	  (queen-cols (- k 1))))))
  (queen-cols board-size))
(queens 8)
