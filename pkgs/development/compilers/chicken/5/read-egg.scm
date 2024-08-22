(import (chicken process-context)
        (chicken format)
        (chicken string))

(define env-var get-environment-variable)
(define ref alist-ref)

(define egg (read))

(printf "[~A]\n" (env-var "EGG_NAME"))

(define dependencies
  (map (lambda (dep)
         (->string (if (list? dep)
                       (car dep)
                       dep)))
       (append
        (ref 'dependencies egg eqv? '())
        ;; TODO separate this into `buildInputs` and `propagatedBuildInputs`
        (ref 'build-dependencies egg eqv? '()))))
(printf "dependencies = [~A]\n"
        (string-intersperse (map (lambda (dep) (sprintf "~S" dep))
                                 dependencies)
                            ", "))

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
