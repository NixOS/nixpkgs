#lang racket/base
(require
 racket/file
 racket/function
 racket/list
 racket/path
 racket/pretty
 racket/string
 pkg/lib
 setup/dirs

 "./hash-shortcuts.rkt"
 "./layering.rkt"
 )
(provide
 env-set?
 env-split
 pathstr
 common-subpath
 outpath

 get-dep-paths
 get-lib-paths

 get-current-config
 get-dep-configs
 new-layer
 new-pkgs-config
 new-racket-config
 write-config
 )

(define env-set?
  (lambda (e)
    (let ([val (getenv e)])
      (and val (not (string=? val ""))))))

(define env-split
  (lambda (e)
    (string-split (or (getenv e) ""))))

(define pathstr
  (compose some-system-path->string build-path))

(define common-subpath
  (lambda (roots . ps)
    (map (lambda (r) (apply pathstr r ps))
         roots)))

(define outpath
  (lambda ps
    (apply pathstr
           (or (getenv "out")
               (error 'outpath "The environment variable `out` is not set. Are you really in the standard environment?"))
           ps)))

;; Dependencies

(define get-dep-paths
  (thunk
   ((compose remove-duplicates append)
    (env-split "depsHostHost")
    (env-split "depsHostHostPropagated")
    (env-split "buildInputs")
    (env-split "propagatedBuildInputs"))))

(define get-lib-paths
  (thunk
   ((compose remove-duplicates
             (curry map (curryr string-trim "-L" #:right? #f))
             (curry filter (curryr string-prefix? "-L")))
    (env-split "NIX_LDFLAGS"))))

;; Racket configuration

(define get-current-config
  (letrec
      ([stringify
        (lambda (v)
          (cond
            [(path? v) (some-system-path->string v)]
            [(list? v) (map stringify v)]
            [else v]))])
    (thunk
     (parameterize ([use-user-specific-search-paths #f])
       (hash-map/copy
        (/:&
         (read-installation-configuration-table)
         'base-documentation-packages (get-base-documentation-packages)
         'bin-search-dirs (get-console-bin-search-dirs)
         'catalogs (pkg-config-catalogs)
         'collects-search-dirs (get-main-collects-search-dirs)
         'compiled-file-roots (find-compiled-file-roots)
         'distribution-documentation-packages (get-distribution-documentation-packages)
         'doc-search-dirs (get-doc-search-dirs)
         'gui-bin-search-dirs (get-gui-bin-search-dirs)
         'include-search-dirs (get-include-search-dirs)
         'lib-search-dirs (get-lib-search-dirs)
         'links-search-files (get-links-search-files)
         'man-search-dirs (get-man-search-dirs)
         'pkgs-search-dirs (get-pkgs-search-dirs)
         'share-search-dirs (get-share-search-dirs)
         )
        (lambda (k v) (values k (stringify v))))))))

(define get-dep-configs
  (thunk
   ((compose (curry map expand-config)
             (curry map file->value)
             (curry filter file-exists?)
             (curryr common-subpath "etc/racket/config.rktd"))
    (get-dep-paths))))

(define new-layer
  (thunk
   (hash
    'apps-dir (outpath "share/applications")
    'bin-dir (outpath "bin")
    'doc-dir (outpath "share/doc/racket")
    'gui-bin-dir (outpath "bin")
    'include-dir (outpath "include/racket")
    'lib-dir (outpath "lib/racket")
    'lib-search-dirs (append (get-lib-paths) '(#f))
    'links-file (outpath "share/racket/links.rktd")
    'man-dir (outpath "share/man")
    'pkgs-dir (outpath "share/racket/pkgs")
    'share-dir (outpath "share/racket")
    )))

(define new-pkgs-config
  (thunk
   (let* ([layers
           (cons (get-current-config) (append (get-dep-configs) (list (new-layer))))])
     (apply config-cascade layers))))

(define new-racket-config
  (thunk
   (/:&
    (new-pkgs-config)
    'config-tethered-console-bin-dir (outpath "bin")
    'config-tethered-gui-bin-dir (outpath "bin")
    )))

(define write-config
  (lambda (config
           #:output-dir [output-dir (outpath "etc/racket")])
    (make-directory* output-dir)
    (with-output-to-file (build-path output-dir "config.rktd")
      #:exists 'replace
      (thunk (pretty-write config)))
    (displayln output-dir)))
