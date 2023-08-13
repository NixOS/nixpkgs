(unless (find-package :ql-to-nix-util)
  (load "util.lisp"))
(unless (find-package :ql-to-nix-quicklisp-bootstrap)
  (load "quicklisp-bootstrap.lisp"))
(defpackage :ql-to-nix
  (:use :common-lisp :ql-to-nix-util :ql-to-nix-quicklisp-bootstrap))
(in-package :ql-to-nix)

;; We're going to pull in our dependencies at image dumping time in an
;; isolated quicklisp installation.  Unfortunately, that means that we
;; can't yet access the symbols for our dependencies.  We can probably
;; do better (by, say, loading these dependencies before this file),
;; but...

(defvar *required-systems* nil)

(push :cl-emb *required-systems*)
(wrap :cl-emb register-emb)
(wrap :cl-emb execute-emb)

(push :external-program *required-systems*)
(wrap :external-program run)

(push :cl-ppcre *required-systems*)
(wrap :cl-ppcre split)
(wrap :cl-ppcre regex-replace-all)
(wrap :cl-ppcre scan)

(push :alexandria *required-systems*)
(wrap :alexandria read-file-into-string)
(wrap :alexandria write-string-into-file)

(push :md5 *required-systems*)
(wrap :md5 md5sum-file)

(wrap :ql-dist find-system)
(wrap :ql-dist release)
(wrap :ql-dist provided-systems)
(wrap :ql-dist archive-url)
(wrap :ql-dist local-archive-file)
(wrap :ql-dist ensure-local-archive-file)
(wrap :ql-dist archive-md5)
(wrap :ql-dist name)
(wrap :ql-dist short-description)

(defun escape-filename (s)
  (format
   nil "~a~{~a~}"
   (if (scan "^[a-zA-Z_]" s) "" "_")
   (loop
      for x in (map 'list 'identity s)
      collect
        (case x
          (#\/ "_slash_")
          (#\\ "_backslash_")
          (#\_ "__")
          (#\. "_dot_")
          (#\+ "_plus_")
          (t x)))))

(defvar *system-info-bin*
  (let* ((path (uiop:getenv "system-info"))
         (path-dir (if (equal #\/ (aref path (1- (length path))))
                       path
                       (concatenate 'string path "/")))
         (pathname (parse-namestring path-dir)))
    (merge-pathnames #P"bin/quicklisp-to-nix-system-info" pathname))
  "The path to the quicklisp-to-nix-system-info binary.")

(defvar *cache-dir* nil
  "The folder where fasls will be cached.")

(defun raw-system-info (system-name)
  "Run quicklisp-to-nix-system-info on the given system and return the
form produced by the program."
  (when *cache-dir*
    (let ((command `(,*system-info-bin* "--cacheDir" ,(namestring *cache-dir*) ,system-name)))
      (handler-case
          (return-from raw-system-info
            (read (make-string-input-stream (uiop:run-program command :output :string))))
        (error (e)
          ;; Some systems don't like the funky caching that we're
          ;; doing.  That's okay.  Let's try it uncached before we
          ;; give up.
          (warn "Unable to use cache for system ~A.~%~A" system-name e)))))
  (read (make-string-input-stream (uiop:run-program `(,*system-info-bin* ,system-name) :output :string))))

(defvar *system-data-memoization-path* nil
  "The path to the folder where fully-resolved system information can
be cached.

If information for a system is found in this directory, `system-data'
will use it instead of re-computing the system data.")

(defvar *system-data-in-memory-memoization*
  (make-hash-table :test #'equalp))

(defun memoized-system-data-path (system)
  "Return the path to the file that (if it exists) contains
pre-computed system data."
  (when *system-data-memoization-path*
    (merge-pathnames
      (make-pathname
        :name (escape-filename (string system))
        :type "txt") *system-data-memoization-path*)))

(defun memoized-system-data (system)
  "Attempts to locate memoized system data in the path specified by
`*system-data-memoization-path*'."
  (multiple-value-bind (value found) (gethash system *system-data-in-memory-memoization*)
    (when found
      (return-from memoized-system-data (values value found))))
  (let ((path (memoized-system-data-path system)))
    (unless path
      (return-from memoized-system-data (values nil nil)))
    (with-open-file (s path :if-does-not-exist nil :direction :input)
      (unless s
        (return-from memoized-system-data (values nil nil)))
      (return-from memoized-system-data (values (read s) t)))))

(defun set-memoized-system-data (system data)
  "Store system data in the path specified by
`*system-data-memoization-path*'."
  (setf (gethash system *system-data-in-memory-memoization*) data)
  (let ((path (memoized-system-data-path system)))
    (unless path
      (return-from set-memoized-system-data data))
    (with-open-file (s path :direction :output :if-exists :supersede)
      (format s "~W" data)))
  data)

(defun system-data (system)
  "Examine a quicklisp system name and figure out everything that is
required to produce a nix package.

This function stores results for memoization purposes in files within
`*system-data-memoization-path*'."
  (multiple-value-bind (value found) (memoized-system-data system)
    (when found
      (return-from system-data value)))
  (format t "Examining system ~A~%" system)
  (let* ((system-info (raw-system-info system))
         (host (getf system-info :host))
         (host-name (getf system-info :host-name))
         (name (getf system-info :name)))
    (when host
      (return-from system-data
        (set-memoized-system-data
         system
         (list
          :system (getf system-info :system)
          :host host
          :filename (escape-filename name)
          :host-filename (escape-filename host-name)))))

    (let* ((url (getf system-info :url))
           (sha256 (getf system-info :sha256))
           (archive-data (nix-prefetch-url url :expected-sha256 sha256))
           (archive-path (getf archive-data :path))
           (archive-md5 (string-downcase
                         (format nil "~{~16,2,'0r~}"
                                 (map 'list 'identity (md5sum-file archive-path)))))
           (stated-md5 (getf system-info :md5))
           (dependencies (getf system-info :dependencies))
           (deps (mapcar (lambda (x) (list :name x :filename (escape-filename x)))
                         dependencies))
           (description (getf system-info :description))
           (siblings (getf system-info :siblings))
           (release-name (getf system-info :release-name))
           (parasites (getf system-info :parasites))
           (version (regex-replace-all
                     (format nil "~a-" name) release-name "")))
      (assert (equal archive-md5 stated-md5))
      (set-memoized-system-data
       system
       (list
        :system system
        :description description
        :sha256 sha256
        :url url
        :md5 stated-md5
        :name name
        :filename (escape-filename name)
        :deps deps
        :dependencies dependencies
        :version version
        :siblings siblings
        :parasites parasites)))))

(defun parasitic-p (data)
  (getf data :host))

(defvar *loaded-from* (or *compile-file-truename* *load-truename*)
  "Where this source file is located.")

(defun this-file ()
  "Where this source file is located or an error."
  (or *loaded-from* (error "Not sure where this file is located!")))

(defun nix-expression (system)
  (execute-emb
    "nix-package"
    :env (system-data system)))

(defun nix-invocation (system)
  (let ((data (system-data system)))
    (if (parasitic-p data)
        (execute-emb
         "parasitic-invocation"
         :env data)
        (execute-emb
         "invocation"
         :env data))))

(defun systems-closure (systems)
  (let*
    ((seen (make-hash-table :test 'equal)))
    (loop
      with queue := systems
      with res := nil
      while queue
      for next := (pop queue)
      for old := (gethash next seen)
      for data := (unless old (system-data next))
      for deps := (getf data :dependencies)
      for siblings := (getf data :siblings)
      unless old do
      (progn
        (push next res)
        (setf queue (append queue deps)))
      do (setf (gethash next seen) t)
      finally (return res))))

(defun ql-to-nix (target-directory)
  (let*
    ((systems
       (split
         (format nil "~%")
         (read-file-into-string
          (format nil "~a/quicklisp-to-nix-systems.txt" target-directory))))
     (closure (systems-closure systems))
     (invocations
       (loop for s in closure
             collect (list :code (nix-invocation s)))))
    (loop
      for s in closure
       do (unless (parasitic-p (system-data s))
            (write-string-into-file
             (nix-expression s)
             (format nil "~a/quicklisp-to-nix-output/~a.nix"
                     target-directory (escape-filename s))
             :if-exists :supersede)))
    (write-string-into-file
      (execute-emb
        "top-package"
        :env (list :invocations invocations))
      (format nil "~a/quicklisp-to-nix.nix" target-directory)
      :if-exists :supersede)))

(defun print-usage-and-quit ()
  "Does what it says on the tin."
  (format *error-output* "Usage:
    ~A [--help] [--cacheSystemInfoDir <path>] [--cacheFaslDir <path>] <work-dir>
Arguments:
    --cacheSystemInfoDir Store computed system info in the given directory
    --cacheFaslDir Store intermediate fast load files in the given directory
    --help Print usage and exit
    <work-dir> Path to directory with quicklisp-to-nix-systems.txt
" (uiop:argv0))
  (uiop:quit 2))

(defun main ()
  "Make it go"
  (let ((argv (uiop:command-line-arguments))
        work-directory
        cache-system-info-directory
        cache-fasl-directory)
    (loop :while argv :for arg = (pop argv) :do
       (cond
         ((equal arg "--cacheSystemInfoDir")
          (unless argv
            (format *error-output* "--cacheSystemInfoDir requires an argument~%")
            (print-usage-and-quit))
          (setf cache-system-info-directory (pop argv)))

         ((equal arg "--cacheFaslDir")
          (unless argv
            (format *error-output* "--cacheFaslDir requires an argument~%")
            (print-usage-and-quit))
          (setf cache-fasl-directory (pop argv)))

         ((equal arg "--help")
          (print-usage-and-quit))

         (t
          (when argv
            (format *error-output* "Only one positional argument allowed~%")
            (print-usage-and-quit))
          (setf work-directory arg))))

    (when cache-system-info-directory
      (setf cache-system-info-directory (pathname-as-directory (pathname cache-system-info-directory)))
      (ensure-directories-exist cache-system-info-directory))

    (labels
        ((make-go (*cache-dir*)
           (format t "Caching fasl files in ~A~%" *cache-dir*)

           (let ((*system-data-memoization-path* cache-system-info-directory))
             (ql-to-nix work-directory))))
      (if cache-fasl-directory
          (make-go (truename (pathname-as-directory (parse-namestring (ensure-directories-exist cache-fasl-directory)))))
          (with-temporary-directory (*cache-dir*)
            (make-go *cache-dir*))))))

(defun dump-image ()
  "Make an executable"
  (dolist (system *required-systems*)
    (asdf:make system))
  (register-emb "nix-package" (merge-pathnames #p"nix-package.emb" (this-file)))
  (register-emb "invocation" (merge-pathnames #p"invocation.emb" (this-file)))
  (register-emb "parasitic-invocation" (merge-pathnames #p"parasitic-invocation.emb" (this-file)))
  (register-emb "top-package" (merge-pathnames #p"top-package.emb" (this-file)))
  (setf uiop:*image-entry-point* #'main)
  (setf uiop:*lisp-interaction* nil)
  (setf *loaded-from* nil) ;; Break the link to our source
  (uiop:dump-image "quicklisp-to-nix" :executable t))
