(unless (find-package :ql-to-nix-util)
  (load "util.lisp"))
(unless (find-package :ql-to-nix-quicklisp-bootstrap)
  (load "quicklisp-bootstrap.lisp"))
(defpackage :ql-to-nix-system-info
  (:use :common-lisp :ql-to-nix-quicklisp-bootstrap :ql-to-nix-util)
  (:export #:dump-image))
(in-package :ql-to-nix-system-info)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *implementation-systems*
    (append
      #+sbcl(list :sb-posix :sb-bsd-sockets :sb-rotate-byte :sb-cltl2
                  :sb-introspect :sb-rt :sb-concurrency)))
  (mapcar (function require) *implementation-systems*))

(declaim (optimize (debug 3) (speed 0) (space 0) (compilation-speed 0) (safety 3)))

;; This file cannot have any dependencies beyond quicklisp and asdf.
;; Otherwise, we'll miss some dependencies!

;; (Implementation-provided dependencies are special, though)

;; We can't load quicklisp until runtime (at which point we'll create
;; an isolated quicklisp installation).  These wrapper functions are
;; nicer than funcalling intern'd symbols every time we want to talk
;; to quicklisp.
(wrap :ql apply-load-strategy)
(wrap :ql compute-load-strategy)
(wrap :ql show-load-strategy)
(wrap :ql quicklisp-systems)
(wrap :ql ensure-installed)
(wrap :ql quicklisp-releases)
(wrap :ql-dist archive-md5)
(wrap :ql-dist archive-url)
(wrap :ql-dist ensure-local-archive-file)
(wrap :ql-dist find-system)
(wrap :ql-dist local-archive-file)
(wrap :ql-dist name)
(wrap :ql-dist provided-systems)
(wrap :ql-dist release)
(wrap :ql-dist short-description)
(wrap :ql-dist system-file-name)
(wrap :ql-impl-util call-with-quiet-compilation)

(defvar *version* (uiop:getenv "version")
  "The version number of this program")

(defvar *main-system* nil
  "The name of the system we're trying to extract info from.")

(defvar *found-parasites* (make-hash-table :test #'equalp)
  "Names of systems which have been identified as parasites.

A system is parasitic if its name doesn't match the name of the file
it is defined in.  So, for example, if foo and foo-bar are both
defined in a file named foo.asd, foo would be the host system and
foo-bar would be a parasitic system.

Parasitic systems are not generally loaded without loading the host
system first.

Keys are system names.  Values are unspecified.")

(defvar *found-dependencies* (make-hash-table :test #'equalp)
  "Hash table containing the set of dependencies discovered while installing a system.

Keys are system names.  Values are unspecified.")

(defun decode-asdf-dependency (name)
  "Translates an asdf system dependency description into a system name.

For example, translates (:version :foo \"1.0\") into \"foo\"."
  (etypecase name
    (symbol
     (setf name (symbol-name name)))
    (string)
    (cons
     (ecase (first name)
       (:version
        (warn "Discarding version information ~A" name)
        ;; There's nothing we can do about this.  If the version we
        ;; have around is good enough, then we're golden.  If it isn't
        ;; good enough, then we'll error out and let a human figure it
        ;; out.
        (setf name (second name))
        (return-from decode-asdf-dependency
          (decode-asdf-dependency name)))

       (:feature
        (if (find (second name) *features*)
            (return-from decode-asdf-dependency
              (decode-asdf-dependency (third name)))
            (progn
              (warn "Dropping dependency due to missing feature: ~A" name)
              (return-from decode-asdf-dependency nil))))

       (:require
        ;; This probably isn't a dependency we can satisfy using
        ;; quicklisp, but we might as well try anyway.
        (return-from decode-asdf-dependency
          (decode-asdf-dependency (second name)))))))
  (string-downcase name))

(defun found-new-parasite (system-name)
  "Record that the given system has been identified as a parasite."
  (setf system-name (decode-asdf-dependency system-name))
  (setf (gethash system-name *found-parasites*) t)
  (when (nth-value 1 (gethash system-name *found-dependencies*))
    (error "Found dependency on parasite")))

(defun known-parasite-p (system-name)
  "Have we previously identified this system as a parasite?"
  (nth-value 1 (gethash system-name *found-parasites*)))

(defun found-parasites ()
  "Return a vector containing all identified parasites."
  (let ((systems (make-array (hash-table-size *found-parasites*) :fill-pointer 0)))
    (loop :for system :being :the :hash-keys :of *found-parasites* :do
       (vector-push system systems))
    systems))

(defvar *track-dependencies* nil
  "When this variable is nil, found-new-dependency will not record
depdendencies.")

(defun parasitic-relationship-p (potential-host potential-parasite)
  "Returns t if potential-host and potential-parasite have a parasitic relationship.

See `*found-parasites*'."
  (let ((host-ql-system (find-system potential-host))
        (parasite-ql-system (find-system potential-parasite)))
    (and host-ql-system parasite-ql-system
         (not (equal (name host-ql-system)
                     (name parasite-ql-system)))
         (equal (system-file-name host-ql-system)
                (system-file-name parasite-ql-system)))))

(defun found-new-dependency (name)
  "Record that the given system has been identified as a dependency.

The named system may not be recorded as a dependency.  It may be left
out for any number of reasons.  For example, if `*track-dependencies*'
is nil then this function does nothing.  If the named system isn't a
quicklisp system, this function does nothing."
  (setf name (decode-asdf-dependency name))
  (unless name
    (return-from found-new-dependency))
  (unless *track-dependencies*
    (return-from found-new-dependency))
  (when (known-parasite-p name)
    (return-from found-new-dependency))
  (when (parasitic-relationship-p *main-system* name)
    (found-new-parasite name)
    (return-from found-new-dependency))
  (unless (find-system name)
    (return-from found-new-dependency))
  (setf (gethash name *found-dependencies*) t))

(defun forget-dependency (name)
  "Whoops.  Did I say that was a dependency?  My bad.

Be very careful using this function!  You can remove a system from the
dependency list, but you can't remove other effects associated with
this system.  For example, transitive dependencies might still be in
the dependency list."
  (setf name (decode-asdf-dependency name))
  (remhash name *found-dependencies*))

(defun found-dependencies ()
  "Return a vector containing all identified dependencies."
  (let ((systems (make-array (hash-table-size *found-dependencies*) :fill-pointer 0)))
    (loop :for system :being :the :hash-keys :of *found-dependencies* :do
       (vector-push system systems))
    systems))

(defun host-system (system-name)
  "If the given system is a parasite, return the name of the system that is its host.

See `*found-parasites*'."
  (let* ((system (find-system system-name))
         (host-file (system-file-name system)))
    (unless (equalp host-file system-name)
      host-file)))

(defun get-loaded (system)
  "Try to load the named system using quicklisp and record any
dependencies quicklisp is aware of.

Unlike `our-quickload', this function doesn't attempt to install
missing dependencies."
  ;; Let's get this party started!
  (let* ((strategy (compute-load-strategy system))
         (ql-systems (quicklisp-systems strategy)))
    (dolist (dep ql-systems)
      (found-new-dependency (name dep)))
    (show-load-strategy strategy)
    (labels
        ((make-go ()
           (apply-load-strategy strategy)))
      (call-with-quiet-compilation #'make-go)
      (let ((asdf-system (asdf:find-system system)))
        ;; If ASDF says that it needed a system, then we should
        ;; probably track that.
        (dolist (asdf-dep (asdf:component-sideway-dependencies asdf-system))
          (found-new-dependency asdf-dep))
        (dolist (asdf-dep (asdf:system-defsystem-depends-on asdf-system))
          (found-new-dependency asdf-dep))))))

(defun our-quickload (system)
  "Attempt to install a package like quicklisp would, but record any
dependencies that are detected during the install."
  (setf system (string-downcase system))
  ;; Load it quickly, but do it OUR way.  Turns out our way is very
  ;; similar to the quicklisp way...
  (let ((already-tried (make-hash-table :test #'equalp))) ;; Case insensitive
    (tagbody
     retry
       (handler-case
           (get-loaded system)
         (asdf/find-component:missing-dependency (e)
           (let ((required-by (asdf/find-component:missing-required-by e))
                 (missing (asdf/find-component:missing-requires e)))
             (unless (typep required-by 'asdf:system)
               (error e))
             (when (gethash missing already-tried)
               (error "Dependency loop? ~A" missing))
             (setf (gethash missing already-tried) t)
             (let ((parasitic-p (parasitic-relationship-p *main-system* missing)))
               (if parasitic-p
                   (found-new-parasite missing)
                   (found-new-dependency missing))
               ;; We always want to track the dependencies of systems
               ;; that share an asd file with the main system.  The
               ;; whole asd file should be loadable.  Otherwise, we
               ;; don't want to include transitive dependencies.
               (let ((*track-dependencies* parasitic-p))
                 (our-quickload missing)))
             (format t "Attempting to load ~A again~%" system)
             (go retry)))))))

(defvar *blacklisted-parasites*
  #("hu.dwim.stefil/documentation" ;; This system depends on :hu.dwim.stefil.test, but it should depend on hu.dwim.stefil/test
    "named-readtables/doc" ;; Dependency cycle between named-readtabes and mgl-pax
    "symbol-munger-test" ;; Dependency cycle between lisp-unit2 and symbol-munger
    "cl-postgres-simple-date-tests" ;; Dependency cycle between cl-postgres and simple-date
    "cl-containers/with-variates" ;; Symbol conflict between cl-variates:next-element, metabang.utilities:next-element
    "serapeum/docs" ;; Weird issue with FUN-INFO redefinition
    "spinneret/cl-markdown" ;; Weird issue with FUN-INFO redefinition
    "spinneret/ps" ;; Weird issue with FUN-INFO redefinition
    "spinneret/tests") ;; Weird issue with FUN-INFO redefinition
  "A vector of systems that shouldn't be loaded by `quickload-parasitic-systems'.

These systems are known to be troublemakers.  In some sense, all
parasites are troublemakers (you shouldn't define parasitic systems!).
However, these systems prevent us from generating nix packages and are
thus doubly evil.")

(defvar *blacklisted-parasites-table*
  (let ((ht (make-hash-table :test #'equalp)))
    (loop :for system :across *blacklisted-parasites* :do
       (setf (gethash system ht) t))
    ht)
  "A hash table where each entry in `*blacklisted-parasites*' is an
entry in the table.")

(defun blacklisted-parasite-p (system-name)
  "Returns non-nil if the named system is blacklisted"
  (nth-value 1 (gethash system-name *blacklisted-parasites-table*)))

(defun quickload-parasitic-systems (system)
  "Attempt to load all the systems defined in the same asd as the named system.

Blacklisted systems are skipped.  Dependencies of the identified
parasitic systems will be tracked."
  (let* ((asdf-system (asdf:find-system system))
         (source-file (asdf:system-source-file asdf-system)))
    (cond
      (source-file
       (loop :for system-name :being :the :hash-keys :of asdf/find-system::*registered-systems* :do
             ; for an unclear reason, a literal 0 which is not a key in the hash table gets observed
          (when (and (gethash system-name asdf/find-system::*registered-systems*)
                     (parasitic-relationship-p system system-name)
                     (not (blacklisted-parasite-p system-name)))
            (found-new-parasite system-name)
            (let ((*track-dependencies* t))
              (our-quickload system-name)))))
      (t
       (unless (or (equal "uiop" system)
                   (equal "asdf" system))
         (warn "No source file for system ~A.  Can't identify parasites." system))))))

(defun determine-dependencies (system)
  "Load the named system and return a sorted vector containing all the
quicklisp systems that were loaded to satisfy dependencies.

This function should probably only be called once per process!
Subsequent calls will miss dependencies identified by earlier calls."
  (tagbody
   retry
     (restart-case
         (let ((*standard-output* (make-broadcast-stream))
               (*trace-output* (make-broadcast-stream))
               (*main-system* system)
               (*track-dependencies* t))
           (our-quickload system)
           (quickload-parasitic-systems system))
       (try-again ()
         :report "Start the quickload over again"
         (go retry))
       (die ()
         :report "Just give up and die"
         (uiop:quit 1))))

  ;; Systems can't depend on themselves!
  (forget-dependency system)
  (values))

(defun parasitic-system-data (parasite-system)
  "Return a plist of information about the given known-parastic system.

Sometimes we are asked to provide information about a system that is
actually a parasite.  The only correct response is to point them
toward the host system.  The nix package for the host system should
have all the dependencies for this parasite already recorded.

The plist is only meant to be consumed by other parts of
quicklisp-to-nix."
  (let ((host-system (host-system parasite-system)))
    (list
     :system parasite-system
     :host host-system
     :name (string-downcase (format nil "~a" parasite-system))
     :host-name (string-downcase (format nil "~a" host-system)))))

(defun system-data (system)
  "Produce a plist describing a system.

The plist is only meant to be consumed by other parts of
quicklisp-to-nix."
  (when (host-system system)
    (return-from system-data
      (parasitic-system-data system)))

  (determine-dependencies system)
  (let*
      ((dependencies (sort (found-dependencies) #'string<))
       (parasites (coerce (sort (found-parasites) #'string<) 'list))
       (ql-system (find-system system))
       (ql-release (release ql-system))
       (ql-sibling-systems (provided-systems ql-release))
       (url (archive-url ql-release))
       (local-archive (local-archive-file ql-release))
       (local-url (format nil "file://~a" (pathname local-archive)))
       (archive-data
        (progn
          (ensure-local-archive-file ql-release)
          ;; Stuff this archive into the nix store.  It was almost
          ;; certainly going to end up there anyway (since it will
          ;; probably be fetchurl'd for a nix package).  Also, putting
          ;; it into the store also gives us the SHA we need.
          (nix-prefetch-url local-url)))
       (ideal-md5 (archive-md5 ql-release))
       (raw-dependencies (coerce dependencies 'list))
       (name (string-downcase (format nil "~a" system)))
       (ql-sibling-names
        (remove name (mapcar 'name ql-sibling-systems)
                :test 'equal))
       (dependencies raw-dependencies)
       (description
         (or
           (ignore-errors (asdf:system-description (asdf:find-system system)))
           "System lacks description"))
       (release-name (short-description ql-release)))
    (list
     :system system
     :description description
     :sha256 (getf archive-data :sha256)
     :url url
     :md5 ideal-md5
     :name name
     :dependencies dependencies
     :siblings ql-sibling-names
     :release-name release-name
     :parasites parasites)))

(defvar *error-escape-valve* *error-output*
  "When `*error-output*' is rebound to inhibit spew, this stream will
still produce output.")

(defun print-usage-and-quit ()
  "Describe how to use this program... and then exit."
  (format *error-output* "Usage:
    ~A [--cacheDir <dir>] [--silent] [--debug] [--help|-h] <system-name>
Arguments:
    --cacheDir Store (and look for) compiled lisp files in the given directory
    --verbose Show compilation output
    --debug Enter the debugger when a fatal error is encountered
    --help Print usage and exit
    <system-name> The quicklisp system to examine
" (or (uiop:argv0) "quicklisp-to-nix-system-info"))
  (uiop:quit 2))

(defun main ()
  "Make it go."
  (let ((argv (uiop:command-line-arguments))
        cache-dir
        target-system
        verbose-p
        debug-p)
    (handler-bind
        ((warning
          (lambda (w)
            (format *error-escape-valve* "~A~%" w)))
         (error
          (lambda (e)
            (if debug-p
                (invoke-debugger e)
                (progn
                  (format *error-escape-valve* "~
Failed to extract system info. Details are below. ~
Run with --debug and/or --verbose for more info.
~A~%" e)
                  (uiop:quit 1))))))
      (loop :while argv :do
         (cond
           ((equal "--cacheDir" (first argv))
            (pop argv)
            (unless argv
              (error "--cacheDir expects an argument"))
            (setf cache-dir (first argv))
            (pop argv))

           ((equal "--verbose" (first argv))
            (setf verbose-p t)
            (pop argv))

           ((equal "--debug" (first argv))
            (setf debug-p t)
            (pop argv))

           ((or (equal "--help" (first argv))
                (equal "-h" (first argv)))
            (print-usage-and-quit))

           (t
            (setf target-system (pop argv))
            (when argv
              (error "Can only operate on one system")))))

      (unless target-system
        (print-usage-and-quit))

      (when cache-dir
        (setf cache-dir (pathname-as-directory (parse-namestring cache-dir))))

      (mapcar (function require) *implementation-systems*)

      (with-quicklisp (dir) (:cache-dir (or cache-dir :temp))
        (declare (ignore dir))

        (let (system-data)
          (let ((*error-output* (if verbose-p
                                    *error-output*
                                    (make-broadcast-stream)))
                (*standard-output* (if verbose-p
                                       *standard-output*
                                       (make-broadcast-stream)))
                (*trace-output* (if verbose-p
                                    *trace-output*
                                    (make-broadcast-stream))))
            (format *error-output*
                    "quicklisp-to-nix-system-info ~A~%ASDF ~A~%Quicklisp ~A~%Compiler ~A ~A~%"
                    *version*
                    (asdf:asdf-version)
                    (funcall (intern "CLIENT-VERSION" :ql))
                    (lisp-implementation-type)
                    (lisp-implementation-version))
            (setf system-data (system-data target-system)))

          (cond
            (system-data
             (format t "~W~%" system-data)
             (uiop:quit 0))
            (t
             (format *error-output* "Failed to determine system data~%")
             (uiop:quit 1))))))))

(defun dump-image ()
  "Make an executable"
  (setf uiop:*image-entry-point* #'main)
  (setf uiop:*lisp-interaction* nil)
  (uiop:dump-image "quicklisp-to-nix-system-info" :executable t))
