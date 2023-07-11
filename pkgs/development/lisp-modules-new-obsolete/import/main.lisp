(defpackage org.lispbuilds.nix/main
  (:use :common-lisp
        :org.lispbuilds.nix/database/sqlite
        :org.lispbuilds.nix/repository/quicklisp
        :org.lispbuilds.nix/api))

(in-package org.lispbuilds.nix/main)

(defun resource (name type)
  (make-pathname
   :defaults (asdf:system-source-directory :org.lispbuilds.nix)
   :name name
   :type type))

(defvar *sqlite*
  (make-instance
   'sqlite-database
   :init-file (resource "init" "sql")
   :url "packages.sqlite"))

(defvar *quicklisp*
  (make-instance
   'quicklisp-repository
   :dist-url
   "https://beta.quicklisp.org/dist/quicklisp/2022-11-07/"))

(defun run-importers ()
  (import-lisp-packages *quicklisp* *sqlite*)
  (format t "Imported packages from quicklisp to ~A~%"
          (truename "packages.sqlite")))

(defun gen-nix-file ()
  (database->nix-expression *sqlite* "imported.nix")
  (format t "Dumped nix file to ~a~%"
          (truename "imported.nix")))

(defun main ()
  (format t "~%")
  (run-importers)
  (gen-nix-file))
