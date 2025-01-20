#lang racket/base
(require
 racket/cmdline
 racket/path
 pkg/lib
 setup/setup
 )

(define path-expand
  (compose some-system-path->string normalize-path))

(define checksum
  (command-line
   #:args
   (rev) rev))

(current-pkg-scope 'installation)

(with-pkg-lock
  (pkg-install
   (list (pkg-desc (path-expand "../../../pkgs/base")
                   'dir "base" checksum #t)
         (pkg-desc (path-expand "../../../pkgs/racket-lib")
                   'dir "racket-lib" checksum #f))
   #:dep-behavior 'force
   #:ignore-checksums? #t
   #:use-cache? #f
   ))

(setup
 #:make-user? #f
 #:fail-fast? #t
 )
