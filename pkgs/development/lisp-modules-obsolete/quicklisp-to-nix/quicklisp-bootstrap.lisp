(unless (find-package :ql-to-nix-util)
  (load "ql-to-nix-util.lisp"))
(defpackage :ql-to-nix-quicklisp-bootstrap
  (:use :common-lisp :ql-to-nix-util)
  (:export #:with-quicklisp)
  (:documentation
   "This package provides a way to create a temporary quicklisp installation."))
(in-package :ql-to-nix-quicklisp-bootstrap)

(declaim (optimize (debug 3) (speed 0) (space 0) (compilation-speed 0) (safety 3)))

;; This file cannot have any dependencies beyond quicklisp and asdf.
;; Otherwise, we'll miss some dependencies!

(defvar *quicklisp*
  (namestring (pathname-as-directory (uiop:getenv "quicklisp")))
  "The path to the nix quicklisp package.")

(defun prepare-quicklisp-dir (target-dir quicklisp-prototype-dir)
  "Install quicklisp into the specified `target-dir'.

`quicklisp-prototype-dir' should be the path to the quicklisp nix
package."
  (ensure-directories-exist target-dir)
  (dolist (subdir '(#P"dists/quicklisp/" #P"tmp/" #P"local-projects/" #P"quicklisp/"))
    (ensure-directories-exist (merge-pathnames subdir target-dir)))
  (with-open-file (s (merge-pathnames #P"dists/quicklisp/enabled.txt" target-dir) :direction :output :if-exists :supersede)
    (format s "1~%"))
  (uiop:copy-file
   (merge-pathnames #P"lib/common-lisp/quicklisp/quicklisp-distinfo.txt" quicklisp-prototype-dir)
   (merge-pathnames #P"dists/quicklisp/distinfo.txt" target-dir))
  (uiop:copy-file
   (merge-pathnames #P"lib/common-lisp/quicklisp/asdf.lisp" quicklisp-prototype-dir)
   (merge-pathnames #P"asdf.lisp" target-dir))
  (uiop:copy-file
   (merge-pathnames #P"lib/common-lisp/quicklisp/setup.lisp" quicklisp-prototype-dir)
   (merge-pathnames #P"setup.lisp" target-dir))
  (copy-directory-tree
   (merge-pathnames #P"lib/common-lisp/quicklisp/quicklisp/" quicklisp-prototype-dir)
   (merge-pathnames #P"quicklisp/" target-dir)))

(defun call-with-quicklisp (function &key (target-dir :temp) (cache-dir :temp))
  "Invoke the given function with the path to a quicklisp installation.

Quicklisp will be loaded before the function is called.  `target-dir'
can either be a pathname for the place where quicklisp should be
installed or `:temp' to request installation in a temporary directory.
`cache-dir' can either be a pathname for a place to store fasls or
`:temp' to request caching in a temporary directory."
  (when (find-package :ql)
    (error "Already loaded quicklisp in this process"))
  (labels
      ((make-ql (ql-dir)
         (prepare-quicklisp-dir ql-dir *quicklisp*)
         (with-temporary-asdf-cache (ql-dir)
           (load (merge-pathnames #P"setup.lisp" ql-dir))
           (if (eq :temp cache-dir)
               (funcall function ql-dir)
               (with-asdf-cache (ql-dir cache-dir)
                 (funcall function ql-dir))))))
    (if (eq :temp target-dir)
        (with-temporary-directory (dir)
          (make-ql dir))
        (make-ql target-dir))))

(defmacro with-quicklisp ((quicklisp-dir) (&key (cache-dir :temp)) &body body)
  "Install quicklisp in a temporary directory, load it, bind
`quicklisp-dir' to the path where quicklisp was installed, and then
evaluate `body'.

`cache-dir' can either be a pathname for a place to store fasls or
`:temp' to request caching in a temporary directory."
  `(call-with-quicklisp
    (lambda (,quicklisp-dir)
      ,@body)
    :cache-dir ,cache-dir))
