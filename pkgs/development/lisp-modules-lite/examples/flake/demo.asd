(asdf:defsystem :demo
  :class :package-inferred-system
  :description "Demo app"
  :version "0.1"
  :author "Hraban Luyat"
  :build-operation "program-op"
  :build-pathname "dist/demo"
  :entry-point "demo:main"
  :depends-on ("demo/main"))
