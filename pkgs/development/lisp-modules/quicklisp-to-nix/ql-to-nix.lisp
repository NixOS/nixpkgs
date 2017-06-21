; QuickLisp-to-Nix export
; Requires QuickLisp to be loaded
; Installs the QuickLisp version of all the packages processed (in the
; QuickLisp instance it uses)

(ql:quickload :cl-emb)
(ql:quickload :external-program)
(ql:quickload :cl-ppcre)
(ql:quickload :alexandria)
(ql:quickload :md5)

(defvar testnames (make-hash-table :test 'equal))

(defun nix-prefetch-url (url)
  (let*
    ((stdout nil)
     (stderr nil))
    (setf
      stdout
      (with-output-to-string (so)
        (setf
          stderr
          (with-output-to-string (se)
            (external-program:run
              "nix-prefetch-url"
              (list url)
              :search t :output so :error se)))))
    (let*
      ((path-line (first (last (cl-ppcre:split (format nil "~%") stderr))))
       (path (cl-ppcre:regex-replace-all "path is .(.*)." path-line "\\1")))
      (list
        :sha256 (first (cl-ppcre:split (format nil "~%") stdout))
        :path path
        :md5 (string-downcase
               (format nil "~{~16,2,'0r~}"
                       (map 'list 'identity (md5:md5sum-file path))))))))

(defun escape-filename (s)
  (format 
    nil "~a~{~a~}"
    (if (cl-ppcre:scan "^[a-zA-Z_]" s) "" "_")
    (loop
      for x in (map 'list 'identity s)
      collect
      (case x
        (#\/ "_slash_")
        (#\\ "_backslash_")
        (#\_ "__")
        (#\. "_dot_")
        (t x)))))

(defun system-data (system)
  (let*
    ((asdf-system
       (or
         (ignore-errors (asdf:find-system system))
         (progn
           (ql:quickload system)
           (asdf:find-system system))))
     (ql-system (ql-dist:find-system system))
     (ql-release (ql-dist:release ql-system))
     (ql-sibling-systems (ql-dist:provided-systems ql-release))
     (url (ql-dist:archive-url ql-release))
     (local-archive (ql-dist:local-archive-file ql-release))
     (local-url (format nil "file://~a" (pathname local-archive)))
     (archive-data
       (progn
         (ql-dist:ensure-local-archive-file ql-release)
         (nix-prefetch-url local-url)))
     (ideal-md5 (ql-dist:archive-md5 ql-release))
     (file-md5 (getf archive-data :md5))
     (raw-dependencies (ql-dist:required-systems ql-system))
     (name (string-downcase (format nil "~a" system)))
     (ql-sibling-names
       (remove name (mapcar 'ql-dist:name ql-sibling-systems)
               :test 'equal))
     (dependencies
       (set-difference
         (remove-duplicates
           (remove-if-not 'ql-dist:find-system raw-dependencies)
           :test 'equal)
         ql-sibling-names
         :test 'equal))
     (deps (mapcar (lambda (x) (list :name x :filename (escape-filename x)))
                   dependencies))
     (description (asdf:system-description asdf-system))
     (release-name (ql-dist:short-description ql-release))
     (version (cl-ppcre:regex-replace-all
                (format nil "~a-" name) release-name "")))
    (assert (equal ideal-md5 file-md5))
  (list
    :system system
    :description description
    :sha256 (getf archive-data :sha256)
    :url url
    :md5 file-md5
    :name name
    :testname (gethash name testnames)
    :filename (escape-filename name)
    :deps deps
    :dependencies dependencies
    :version version
    :siblings ql-sibling-names)))

(defmacro this-file ()
  (or *compile-file-truename*
      *load-truename*))

(defun nix-expression (system)
  (cl-emb:execute-emb
    (merge-pathnames #p"nix-package.emb" (this-file))
    :env (system-data system)))
(defun nix-invocation (system)
  (cl-emb:execute-emb
    (merge-pathnames #p"invocation.emb" (this-file))
    :env (system-data system)))

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
  (load (format nil "~a/quicklisp-to-nix-overrides.lisp" target-directory))
  (let*
    ((systems
       (cl-ppcre:split
         (format nil "~%")
         (alexandria:read-file-into-string
           (format nil "~a/quicklisp-to-nix-systems.txt" target-directory))))
     (closure (systems-closure systems))
     (invocations
       (loop for s in closure
             collect (list :code (nix-invocation s)))))
    (loop
      for s in closure
      do (alexandria:write-string-into-file
           (nix-expression s)
           (format nil "~a/quicklisp-to-nix-output/~a.nix"
                   target-directory (escape-filename s))
           :if-exists :supersede))
    (alexandria:write-string-into-file
      (cl-emb:execute-emb
        (merge-pathnames
          #p"top-package.emb"
          (this-file))
        :env (list :invocations invocations))
      (format nil "~a/quicklisp-to-nix.nix" target-directory)
      :if-exists :supersede)))
