(defpackage :ql-to-nix-util
  (:use :common-lisp)
  (:export #:nix-prefetch-url #:wrap #:pathname-as-directory #:copy-directory-tree #:with-temporary-directory #:sym #:with-temporary-asdf-cache #:with-asdf-cache)
  (:documentation
   "A collection of useful functions and macros that ql-to-nix will use."))
(in-package :ql-to-nix-util)

(declaim (optimize (debug 3) (speed 0) (space 0) (compilation-speed 0) (safety 3)))

;; This file cannot have any dependencies beyond quicklisp and asdf.
;; Otherwise, we'll miss some dependencies!

(defun pathname-as-directory (pathname)
  "Given a pathname, make it into a path to a directory.

This is sort of like putting a / at the end of the path."
  (unless (pathname-name pathname)
    (return-from pathname-as-directory pathname))
  (let* ((old-dir (pathname-directory pathname))
         (old-name (pathname-name pathname))
         (old-type (pathname-type pathname))
         (last-dir
          (cond
            (old-type
             (format nil "~A.~A" old-name old-type))
            (t
             old-name)))
         (new-dir (if old-dir
                      (concatenate 'list old-dir (list last-dir))
                      (list :relative last-dir))))

    (make-pathname :name nil :directory new-dir :type nil :defaults pathname)))

(defvar *nix-prefetch-url-bin*
  (namestring (merge-pathnames #P"bin/nix-prefetch-url" (pathname-as-directory (uiop:getenv "nix-prefetch-url"))))
  "The path to the nix-prefetch-url binary")

(defun nix-prefetch-url (url &key expected-sha256)
  "Invoke the nix-prefetch-url program.

Returns a plist with two keys.
:sha256 => The sha of the fetched file
:path => The path to the file in the nix store"
  (when expected-sha256
    (setf expected-sha256 (list expected-sha256)))
  (let* ((stdout
          (with-output-to-string (so)
            (uiop:run-program
             `(,*nix-prefetch-url-bin* "--print-path" ,url ,@expected-sha256)
             :output so)))
         (stream (make-string-input-stream stdout)))
    (list
     :sha256 (read-line stream)
     :path (read-line stream))))

(defmacro wrap (package symbol-name)
  "Create a function which looks up the named symbol at runtime and
invokes it with the same arguments.

If you can't load a system until runtime, this macro gives you an
easier way to write
    (funcall (intern \"SYMBOL-NAME\" :package-name) arg)
Instead, you can write
    (wrap :package-name symbol-name)
    (symbol-name arg)"
  (let ((args (gensym "ARGS")))
    `(defun ,symbol-name (&rest ,args)
       (apply (sym ',package ',symbol-name) ,args))))

(defun copy-directory-tree (src-dir target-dir)
  "Recursively copy every file in `src-dir' into `target-dir'.

This function traverses symlinks."
  (when (or (not (pathname-directory target-dir))
            (pathname-name target-dir))
    (error "target-dir must be a dir"))
  (when (or (not (pathname-directory src-dir))
            (pathname-name src-dir))
    (error "src-dir must be a dir"))
  (let ((src-wild (make-pathname :name :wild :type :wild :defaults src-dir)))
    (dolist (entity (uiop:directory* src-wild))
      (if (pathname-name entity)
          (uiop:copy-file entity (make-pathname :type (pathname-type entity) :name (pathname-name entity) :defaults target-dir))
          (let ((new-target-dir
                 (make-pathname
                  :directory (concatenate 'list (pathname-directory target-dir) (last (pathname-directory entity))))))
            (ensure-directories-exist new-target-dir)
            (copy-directory-tree entity new-target-dir))))))

(defun call-with-temporary-directory (function)
  "Create a temporary directory, invoke the given function by passing
in the pathname for the directory, and then delete the directory."
  (let* ((dir (uiop:run-program '("mktemp" "-d") :output :line))
         (parsed (parse-namestring dir))
         (parsed-as-dir (pathname-as-directory parsed)))
    (assert (uiop:absolute-pathname-p dir))
    (unwind-protect
         (funcall function parsed-as-dir)
      (uiop:delete-directory-tree
       parsed-as-dir
       :validate
       (lambda (path)
         (and (uiop:absolute-pathname-p path)
              (equal (subseq (pathname-directory path) 0 (length (pathname-directory parsed-as-dir)))
                     (pathname-directory parsed-as-dir))))))))

(defmacro with-temporary-directory ((dir-name) &body body)
  "See `call-with-temporary-directory'."
  `(call-with-temporary-directory (lambda (,dir-name) ,@body)))

(defun sym (package sym)
  "A slightly less picky version of `intern'.

Unlike `intern', the `sym' argument can be a string or a symbol.  If
it is a symbol, then the `symbol-name' is `intern'ed into the
specified package.

The arguments are also reversed so that the package comes first."
  (etypecase sym
    (symbol (setf sym (symbol-name sym)))
    (string))
  (intern sym package))

(defvar *touch-bin*
  (namestring (merge-pathnames #P"bin/touch" (pathname-as-directory (uiop:getenv "touch"))))
  "Path to the touch binary.")

(defvar *cache-dir* nil
  "When asdf cache remapping is in effect (see `with-asdf-cache'),
this stores the path to the fasl cache directory.")
(defvar *src-dir* nil
  "When asdf cache remapping is in effect (see `with-asdf-cache'),
this stores the path to the source directory.

Only lisp files within the source directory will have their fasls
cached in the cache directory.")

(defun remap (path prefix)
  "Implements the cache policy described in `with-asdf-cache'."
  (declare (ignore prefix))
  (let* ((ql-dirs (pathname-directory *src-dir*))
         (ql-dirs-length (length ql-dirs))
         (path-prefix (subseq (pathname-directory path) 0 ql-dirs-length))
         (path-postfix (subseq (pathname-directory path) ql-dirs-length)))
    (unless (equal path-prefix ql-dirs)
      (return-from remap path))
    (let ((result (make-pathname :directory (concatenate 'list (pathname-directory *cache-dir*) path-postfix) :defaults path)))
      (with-open-file (s result :direction :probe :if-does-not-exist nil)
        (when s
          (uiop:run-program `(,*touch-bin* ,(namestring result)))))
      result)))

(defmacro with-temporary-asdf-cache ((src-dir) &body body)
  "Create a temporary directory, and then use it as the ASDF cache
directory for source files in `src-dir'.

See `with-asdf-cache'."
  (let ((tmp-dir (gensym "ORIGINAL-VALUE")))
    `(with-temporary-directory (,tmp-dir)
       (with-asdf-cache (,src-dir ,tmp-dir)
         ,@body))))

(defmacro with-asdf-cache ((src-dir cache-dir) &body body)
  "When ASDF compiles a lisp file in `src-dir', store the fasl in `cache-dir'."
  (let ((original-value (gensym "ORIGINAL-VALUE")))
    `(let ((,original-value asdf:*output-translations-parameter*)
           (*src-dir* ,src-dir)
           (*cache-dir* ,cache-dir))
       (unwind-protect
            (progn
              (asdf:initialize-output-translations
               '(:output-translations
                 :INHERIT-CONFIGURATION
                 ;; FIXME: Shouldn't we only be remaping things
                 ;; actually in the src dir?  Oh well.
                 (t (:function remap))))
              ,@body)
         (asdf:initialize-output-translations ,original-value)))))
