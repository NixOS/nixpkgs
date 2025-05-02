#!/usr/bin/env -S sbcl --script

(require :uiop)

;; prevent glibc hell
(setf (uiop:getenv "LD_LIBRARY_PATH") "")

(defparameter packages (uiop:read-file-lines "./lispPackagesToTest.txt"))

(defparameter lisp (or (cadr sb-ext:*posix-argv*) "sbcl"))

(defparameter nix-build "nix-build -E 'with import ../../../../default.nix {}; lispPackages_new.~aPackages.~a'")

(defparameter cpu-count
  (length
   (remove-if-not
    (lambda (line)
      (uiop:string-prefix-p "processor" line))
    (uiop:read-file-lines "/proc/cpuinfo"))))

(defparameter sem (sb-thread:make-semaphore :count cpu-count))

(defparameter statuses (make-hash-table :synchronized t))

(defparameter log-lock (sb-thread:make-mutex))

(format *error-output* "Testing ~a on ~a cores~%" lisp cpu-count)

(defun clear-line ()
  (write-char #\Return *error-output*)
  (write-char #\Escape *error-output*)
  (write-char #\[ *error-output*)
  (write-char #\K *error-output*))

(declaim (type fixnum errors))
(defglobal errors 0)

(defmacro when-let (bindings &rest body)
  (reduce
   (lambda (expansion form)
     (destructuring-bind (var test) form
       (let ((testsym (gensym (symbol-name var))))
         `(let ((,testsym ,test))
            (when ,testsym
              (let ((,var ,testsym))
                ,expansion))))))
   (reverse bindings)
   :initial-value `(progn ,@body)))

(dolist (pkg packages)
  (sb-thread:wait-on-semaphore sem)
  (sb-thread:make-thread
   (lambda ()
     (handler-case
         (unwind-protect
              (multiple-value-bind (out err code)
                  (uiop:run-program
                   (format nil nix-build lisp pkg)
                   :error-output '(:string :stripped t)
                   :ignore-error-status t)
                (declare (ignorable err))
                (setf (gethash pkg statuses) code)
                (when-let ((pos (search "LOAD-FOREIGN-LIBRARY-ERROR" err :test #'string=))
                           (lines (uiop:split-string (subseq err pos) :separator '(#\Newline))))
                  (setf (gethash pkg statuses)
                        (fourth lines)))
                (sb-thread:with-mutex (log-lock)
                  (clear-line)
                  (format *error-output* "[~a/~a] ~[OK~:;ERROR~] ~a~[~:;~%~]"
                          (hash-table-count statuses)
                          (length packages)
                          code
                          pkg
                          code)
                  (force-output *error-output*))
                (unless (zerop code)
                  (sb-ext:atomic-incf errors)))
           (sb-thread:signal-semaphore sem))
       (error (e)
         (format t "~a~%" e)
         (sb-ext:quit :recklessly-p t :unix-status 1))))))

(sb-thread:wait-on-semaphore sem :n cpu-count)

(format t "~%Done (~a/~a)."
        (- (length packages) errors)
        (length packages))

(when (plusp errors)
  (format t "~%~%~a Errors: " errors)
  (maphash (lambda (k v)
             (unless (and (numberp v) (zerop v))
               (format t "~%  ~a: ~a" k v)))
           statuses))
