;; Reads the .egg-info of an installed egg from standard input and writes it
;; back with the version given as the first argument, and with the installed
;; files moved to the repository given as the second argument listed there.
;;
;; The version works around https://bugs.call-cc.org/ticket/1855, which is
;; unfixed as of CHICKEN 6.0.0: eggs whose .egg carries no version property are
;; installed without one. The installed files are shown by chicken-status; the
;; .egg-info is in the dev output with the files moved there, so it may refer
;; to both outputs.

(import (chicken base) (chicken file) (chicken pathname)
        (chicken process-context))

(define version (car (command-line-arguments)))
(define moved-to (cadr (command-line-arguments)))

(define (installed files)
  (if (null? files)
      '()
      (let ((moved (make-pathname moved-to (pathname-strip-directory (car files)))))
        (cond ((file-exists? (car files)) (cons (car files) (installed (cdr files))))
              ((file-exists? moved) (cons moved (installed (cdr files))))
              (else (installed (cdr files)))))))

(write
 (cons (list 'version version)
       (map (lambda (property)
              (if (eq? (car property) 'installed-files)
                  (cons 'installed-files (installed (cdr property)))
                  property))
            (read))))
