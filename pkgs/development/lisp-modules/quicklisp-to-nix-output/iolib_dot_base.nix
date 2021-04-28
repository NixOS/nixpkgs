/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_base";
  version = "iolib-v0.8.3";

  description = "Base IOlib package, used instead of CL.";

  deps = [ args."alexandria" args."iolib_dot_asdf" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz";
    sha256 = "12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c";
  };

  packageName = "iolib.base";

  asdFilesToKeep = ["iolib.base.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.base DESCRIPTION Base IOlib package, used instead of CL.
    SHA256 12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib.base FILENAME iolib_dot_base
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES
    (alexandria iolib.asdf iolib.common-lisp iolib.conf split-sequence) VERSION
    iolib-v0.8.3 SIBLINGS
    (iolib iolib.asdf iolib.common-lisp iolib.conf iolib.examples iolib.grovel
     iolib.tests)
    PARASITES NIL) */
