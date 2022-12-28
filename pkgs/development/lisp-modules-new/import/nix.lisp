(defpackage org.lispbuilds.nix/nix
  (:documentation "Utilities for generating Nix code")
  (:use :cl)
  (:import-from :str)
  (:import-from :ppcre)
  (:import-from :arrow-macros :->>)
  (:import-from :org.lispbuilds.nix/util :replace-regexes)
  (:export
   :nix-eval
   :system-master
   :nixify-symbol
   :make-pname
   :*nix-attrs-depth*))

(in-package org.lispbuilds.nix/nix)

;; Path names are alphanumeric and can include the symbols +-._?= and
;; must not begin with a period.
(defun make-pname (string)
  (replace-regexes '("^[.]" "[^a-zA-Z0-9+-._?=]")
                   '("_" "_")
                   string))

(defun system-master (system)
  (first (str:split "/" system)))

;;;; Nix generation

(defun nix-eval (exp)
  (assert (consp exp))
  (ecase (car exp)
    (:string (nix-string (cadr exp)))
    (:list (apply #'nix-list (rest exp)))
    (:funcall (apply #'nix-funcall (rest exp)))
    (:attrs (nix-attrs (cdr exp)))
    (:merge (apply #'nix-merge (cdr exp)))
    (:symbol (nix-symbol (cadr exp)))))

(defun nix-string (object)
  (format nil "\"~a\"" object))

(defun nixify-symbol (string)
  (flet ((fix-special-chars (str)
           (replace-regexes '("[+]$" "[+][/]" "[+]" "[.]" "[/]")
                            '("_plus" "_plus/" "_plus_" "_dot_" "_slash_")
                            str)))
    (if (ppcre:scan "^[0-9]" string)
        (str:concat "_" (fix-special-chars string))
        (fix-special-chars string))))


(defun nix-symbol (object)
  (nixify-symbol (format nil "~a" object)))

(defun nix-list (&rest things)
  (format nil "[ ~{~A~^ ~} ]" (mapcar 'nix-eval things)))
(defvar *nix-attrs-depth* 0)

(defun nix-attrs (keyvals)
  (let ((*nix-attrs-depth* (1+ *nix-attrs-depth*)))
    (format
     nil
     (->> "{~%*depth*~{~{~A = ~A;~}~^~%*depth*~}~%*depth-1*}"
          (str:replace-all "*depth*" (str:repeat *nix-attrs-depth* "  "))
          (str:replace-all "*depth-1*" (str:repeat (1- *nix-attrs-depth*) "  ")))
     (mapcar (lambda (keyval)
               (let ((key (car keyval))
                     (val (cadr keyval)))
                 (list (nix-symbol key)
                       (nix-eval val))))
             keyvals))))

(defun nix-funcall (fun &rest args)
  (format nil "(~a ~{~a~^ ~})"
          (nixify-symbol fun)
          (mapcar 'nix-eval args)))

(defun nix-merge (a b)
  (format nil "(~a // ~b)"
          (nix-eval a)
          (nix-eval b)))
