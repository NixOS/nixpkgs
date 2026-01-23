(defpackage org.lispbuilds.nix/main
  (:use :common-lisp
        :org.lispbuilds.nix/database/sqlite
        :org.lispbuilds.nix/repository/quicklisp
        :org.lispbuilds.nix/api)
  (:local-nicknames
   (:http :dexador)))

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

(defvar *quicklisp* nil)

(defun get-quicklisp-version ()
  (let ((response (http:get "http://beta.quicklisp.org/dist/quicklisp.txt")))
    (subseq
     (second (uiop:split-string response :separator '(#\Newline)))
     9)))

(defun init-quicklisp ()
  (setf *quicklisp*
        (make-instance
         'quicklisp-repository
         :dist-url
         (format nil
                 "https://beta.quicklisp.org/dist/quicklisp/~a/"
                 (get-quicklisp-version)))))

(defun run-importers ()
  (ignore-errors (delete-file "packages.sqlite"))
  (import-lisp-packages *quicklisp* *sqlite*)
  (format t "Imported packages from quicklisp to ~A~%"
          (truename "packages.sqlite")))

(defun gen-nix-file ()
  (database->nix-expression *sqlite* "imported.nix")
  (format t "Dumped nix file to ~a~%"
          (truename "imported.nix")))

(defun run-nix-formatter ()
  (uiop:run-program '("nixfmt" "imported.nix")))

(defun main ()
  (format t "~%")
  (init-quicklisp)
  (run-importers)
  (gen-nix-file)
  (run-nix-formatter))
