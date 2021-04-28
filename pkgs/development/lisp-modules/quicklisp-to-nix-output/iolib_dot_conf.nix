/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_conf";
  version = "iolib-v0.8.3";

  description = "Compile-time configuration for IOLib.";

  deps = [ args."alexandria" args."iolib_dot_asdf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz";
    sha256 = "12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c";
  };

  packageName = "iolib.conf";

  asdFilesToKeep = ["iolib.conf.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.conf DESCRIPTION Compile-time configuration for IOLib. SHA256
    12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib.conf FILENAME iolib_dot_conf
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf))
    DEPENDENCIES (alexandria iolib.asdf) VERSION iolib-v0.8.3 SIBLINGS
    (iolib iolib.asdf iolib.base iolib.common-lisp iolib.examples iolib.grovel
     iolib.tests)
    PARASITES NIL) */
