(defpackage org.lispbuilds.nix/api
  (:documentation "Public interface of org.lispbuilds.nix")
  (:use :cl)
  (:export
   :import-lisp-packages
   :database->nix-expression))

(in-package org.lispbuilds.nix/api)

(defgeneric import-lisp-packages (repository database)
  (:documentation
   "Import Lisp packages (ASDF systems) from repository (Quicklisp,
   Ultralisp etc.) into a package database."))

(defgeneric database->nix-expression (database outfile)
  (:documentation
   "Generate a nix expression from the package database and write it
   into outfile."))
