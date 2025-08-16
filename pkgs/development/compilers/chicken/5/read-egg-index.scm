(import (chicken io)
        (chicken irregex)
        (chicken sort)
        (chicken string))

(let ((format-version (read (current-input-port))))
  (when (not (equal? "2" format-version))
    (error (string-append "Only supported index format version is 2 but got " format-version))))

;; Copied from chicken-install.scm since it's unfortunately not exported by a core module anymore
(define (version>=? v1 v2)
  (define (version->list v)
    (map (lambda (x) (or (string->number x) x))
	 (irregex-split "[-\\._]" (->string v))))
  (let loop ((p1 (version->list v1))
	     (p2 (version->list v2)))
    (cond ((null? p1) (null? p2))
	  ((null? p2))
	  ((number? (car p1))
	   (and (number? (car p2))
		(or (> (car p1) (car p2))
		    (and (= (car p1) (car p2))
			 (loop (cdr p1) (cdr p2))))))
	  ((number? (car p2)))
	  ((string>? (car p1) (car p2)))
	  (else
	   (and (string=? (car p1) (car p2))
		(loop (cdr p1) (cdr p2)))))))

(define egg-name car)
(define egg-version cadr)
(define egg-sha1 cadddr)

(define latest-releases
  (let loop ((eggs '()))
    (let ((egg (read)))
      (if (eof-object? egg)
          eggs
          (let* ((name (egg-name egg))
                 (existing (assq name eggs)))
            (loop (if (or (not existing)
                          (version>=? (egg-version egg)
                                      (egg-version existing)))
                      (alist-update! name (cdr egg) eggs)
                      eggs)))))))

(define (string-prefix? a b)
  (let ((i (substring-index a b)))
    (and i (zero? i))))

(for-each
 (lambda  (egg)
   (print (egg-name egg)
          "\t"
          (egg-version egg)
          "\t"
          (egg-sha1 egg)))
 (sort latest-releases
       (lambda (a b)
         (let ((a (symbol->string (egg-name a)))
               (b (symbol->string (egg-name b))))
           (or (string-prefix? (string-append b "-") a)
               (and (not (string-prefix? (string-append a "-") b))
                    (string<? a b)))))))
