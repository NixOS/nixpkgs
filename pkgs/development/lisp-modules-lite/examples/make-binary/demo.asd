(asdf:defsystem :demo
  :description "Demo app"
  :version "0.1"
  :author "Hraban Luyat"
  :build-operation "program-op"
  :build-pathname "bin/demo"
  :entry-point "demo:main"
  :depends-on (:alexandria :cl-async)
  :serial t
  :components ((:file "src/package")
               (:file "src/demo")))
