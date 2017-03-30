; QuickLisp-to-Nix export
; Requires QuickLisp to be loaded
; Installs the QuickLisp version of all the packages processed (in the
; QuickLisp instance it uses)

(ql:quickload :cl-emb)
(ql:quickload :external-program)
(ql:quickload :cl-ppcre)
(ql:quickload :md5)
(ql:quickload :alexandria)

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

(defun system-data (system)
  (ql:quickload system)
  (let*
    ((asdf-system (asdf:find-system system))
     (ql-system (ql-dist:find-system system))
     (ql-release (ql-dist:release ql-system))
     (url (ql-dist:archive-url ql-release))
     (local-archive (ql-dist:local-archive-file ql-release))
     (local-url (format nil "file://~a" (pathname local-archive)))
     (archive-data
       (progn
         (ql-dist:ensure-local-archive-file ql-release)
         (nix-prefetch-url local-url)))
     (ideal-md5 (ql-dist:archive-md5 ql-release))
     (file-md5 (getf archive-data :md5))
     (raw-dependencies (asdf:system-depends-on asdf-system))
     (dependencies (remove-if-not 'ql-dist:find-system raw-dependencies))
     (deps (mapcar (lambda (x) (list :name x)) dependencies))
     (name (string-downcase (format nil "~a" system)))
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
    :deps deps
    :dependencies dependencies
    :version version)))

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
      for deps := (getf (system-data next) :dependencies)
      unless (gethash next seen) do
      (progn
        (push next res)
        (setf queue (append queue deps)))
      do (setf (gethash next seen) t)
      finally (return res))))

(defun ql-to-nix (target-directory)
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
           (format nil "~a/quicklisp-to-nix-output/~a.nix" target-directory s)
           :if-exists :supersede))
    (alexandria:write-string-into-file
      (cl-emb:execute-emb
        (merge-pathnames
          #p"top-package.emb"
          (this-file))
        :env (list :invocations invocations))
      (format nil "~a/quicklisp-to-nix.nix" target-directory)
      :if-exists :supersede)))
