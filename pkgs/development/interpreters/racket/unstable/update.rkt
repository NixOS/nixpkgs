#lang racket/base
(require
 racket/function
 racket/port
 racket/string
 racket/system
 net/url
 )

(define /. hash-ref)
(define /.*
  (case-lambda
    [(ht key)
     (hash-ref ht key)]
    [(ht key . further)
     (apply /.* (hash-ref ht key) further)]))

(define fetch
  (lambda (urlstr)
    (let-values ([(status _ body) (http-sendrecv/url (string->url urlstr))])
      (unless (string=? "200" (cadr (string-split (bytes->string/utf-8 status))))
        (error 'fetch "fail to fetch content from URL ~s, status: ~s"
               urlstr status))
      (port->string body #:close? #t))))

(define invoke
  (lambda (command . args)
    (string-trim
     (with-output-to-string
       (thunk
        (let ([exit-code
               (apply system*/exit-code (find-executable-path command) args)])
          (or (= exit-code 0)
              (error 'invoke "process ~s exits with code ~s"
                     (cons command args) exit-code)))))
     "\n"
     #:left? #f)))

(module+ main
  (require
   racket/file
   racket/match
   racket/path
   json
   )

  (define commit-url "https://api.github.com/repos/racket/racket/commits/heads/master")
  (define version-url-template "https://raw.githubusercontent.com/racket/racket/~a/racket/src/version/racket_version.h")
  (define manifest-file "manifest.json")

  (current-locale #f)
  (current-directory (build-path (find-system-path 'run-file) 'up))

  (define commit (string->jsexpr (fetch commit-url)))

  (define rev (/. commit 'sha))
  (let ([prev-rev
         (if (file-exists? manifest-file)
             (/.* (string->jsexpr (file->string manifest-file)) 'args 'rev)
             "")])
    (when (string=? rev prev-rev)
      (error "no newer version available")))

  (define version
    (let ([commit-date
           (let ([full-date (/.* commit 'commit 'committer 'date)])
             (car (string-split full-date "T")))]
          [version-number
           (match-let*
               ([head
                 (fetch (format version-url-template rev))]
                [find-part
                 (compose cadr
                          (curryr regexp-match head)
                          pregexp
                          (curry format "#define\\s+~a\\s+(\\d+)"))]
                [(list x y z w)
                 (map find-part
                      '("MZSCHEME_VERSION_X"
                        "MZSCHEME_VERSION_Y"
                        "MZSCHEME_VERSION_Z"
                        "MZSCHEME_VERSION_W"))])
             (cond
               [(not (string=? w "0"))
                (string-join (list x y z w) ".")]
               [(not (string=? z "0"))
                (string-join (list x y z) ".")]
               [else
                (string-join (list x y) ".")]))])
      (string-append version-number "-unstable-" commit-date)))

  (define args
    (string->jsexpr (invoke "nix-prefetch-github" "racket" "racket" "--rev" rev)))

  (with-output-to-file manifest-file
    #:exists 'replace
    (thunk
     (write-json
      #:indent 2
      (hash 'version version
            'args args))
     (newline)))

  (write-json
   #:indent 2
   (list
    (hash 'attrPath (getenv "UPDATE_NIX_ATTR_PATH")
          'oldVersion (getenv "UPDATE_NIX_OLD_VERSION")
          'newVersion version
          'files ((compose list some-system-path->string normalize-path)
                  manifest-file))))
  (newline)
  )
