#lang racket/base
(provide
 /. /.*
 /?
 /: /:&
 /_
 )

(define /. hash-ref)

(define /.*
  (case-lambda
    [(ht key)
     (hash-ref ht key)]
    [(ht key . further)
     (apply /.* (hash-ref ht key) further)]))

(define /?
  (case-lambda
    [(ht key)
     (hash-has-key? ht key)]
    [(ht key . further)
     (and (hash-has-key? ht key)
          (apply /? (hash-ref ht key) further))]))

(define /:
  (case-lambda
    [(ht key val)
     (hash-set ht key val)]
    [(ht key0 key1 . further)
     (hash-set
      ht key0
      (apply /:
             (if (hash-has-key? ht key0)
                 (hash-ref ht key0)
                 (hash-clear ht))
             key1
             further))]))

(define /:& hash-set*)

(define /_
  (case-lambda
    [(ht key)
     (hash-remove ht key)]
    [(ht key . further)
     (if (hash-has-key? ht key)
         (hash-set
          ht key
          (apply /_ (hash-ref ht key) further))
         ht)]))
