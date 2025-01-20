#lang racket/base
(require racket/file
         racket/function
         racket/list
         racket/path
         racket/string

         pkg/lib
         setup/setup
         "./stdenv.rkt")

(current-pkg-scope 'installation)

(define pkg-dirs
  ((compose
    (curry map some-system-path->string)
    (curry filter directory-exists?)
    flatten
    (curry map (curry directory-list #:build? #t)))
   (common-subpath (get-dep-paths) "share/racket-packages-archive")))

(define pkgs
  (for/fold ([acc '()])
            ([pkg-dir (in-list pkg-dirs)])
    (let* ([checksum
            (let ([checksum-file (build-path pkg-dir ".CHECKSUM")])
              (and (file-exists? checksum-file)
                   (string-trim (file->string checksum-file))))]
           [pkg (pkg-desc pkg-dir 'dir #f checksum #f)])
      (cons pkg acc))))

(with-pkg-lock
  (pkg-install
   pkgs
   #:dep-behavior 'force
   #:force? #t
   #:ignore-checksums? #t
   #:use-cache? #f
   #:link-dirs? #t
   ))

(setup
 #:make-user? #f
 #:fail-fast? #t
 )
