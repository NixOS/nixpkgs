
(require :asdf)
(pushnew (truename "./import") asdf:*central-registry*)
(asdf:load-system :org.lispbuilds.nix)
(load "./import/main.lisp")
(org.lispbuilds.nix/main::main)
