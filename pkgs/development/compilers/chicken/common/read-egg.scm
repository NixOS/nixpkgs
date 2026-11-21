(import (chicken process-context)
        (chicken format)
        (chicken string))

(define env-var get-environment-variable)
(define ref alist-ref)

(define egg (read))

(printf "[~A]\n" (env-var "EGG_NAME"))

(define (format-deps deps)
  (string-intersperse
   (map (lambda (dep)
          (sprintf "~S"
                   (->string (if (list? dep)
                                 (car dep)
                                 dep))))
        (or deps '()))
   ", "))

(printf "dependencies = [~A]\n"
        (format-deps
         (append
          (or (ref 'dependencies egg) '())
          ;; TODO separate this into `buildInputs` and `propagatedBuildInputs`
          (or (ref 'build-dependencies egg) '()))))

(printf "testDependencies = [~A]\n"
        (format-deps (ref 'test-dependencies egg)))

(define license (ref 'license egg))
(printf "license = ~S\n"
        (if (not license)
            ""
            (string-translate (->string (car license))
                              "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
                              "abcdefghijklmnopqrstuvwxyz-")))

(printf "sha256 = ~S\n" (env-var "EGG_SHA256"))

(define synopsis (ref 'synopsis egg))
(printf "synopsis = ~S\n"
        (if (not synopsis)
            ""
            (car synopsis)))

(printf "version = ~S\n" (env-var "EGG_VERSION"))
(print)
