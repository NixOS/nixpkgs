args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_dot_asdf'';
  version = ''iolib-v0.8.3'';

  description = ''A few ASDF component classes.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };

  packageName = "iolib.asdf";

  asdFilesToKeep = ["iolib.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.asdf DESCRIPTION A few ASDF component classes. SHA256
    12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib.asdf FILENAME iolib_dot_asdf
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria)
    VERSION iolib-v0.8.3 SIBLINGS
    (iolib iolib.base iolib.common-lisp iolib.conf iolib.examples iolib.grovel
     iolib.tests)
    PARASITES NIL) */
