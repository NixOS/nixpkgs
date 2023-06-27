/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_grovel";
  version = "iolib-v0.8.3";

  description = "The CFFI Groveller";

  deps = [ args."alexandria" args."babel" args."cffi" args."iolib_dot_asdf" args."iolib_dot_base" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."split-sequence" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz";
    sha256 = "12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c";
  };

  packageName = "iolib.grovel";

  asdFilesToKeep = ["iolib.grovel.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.grovel DESCRIPTION The CFFI Groveller SHA256
    12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib.grovel FILENAME
    iolib_dot_grovel DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.base FILENAME iolib_dot_base)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria babel cffi iolib.asdf iolib.base iolib.common-lisp iolib.conf
     split-sequence trivial-features uiop)
    VERSION iolib-v0.8.3 SIBLINGS
    (iolib iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples
     iolib.tests)
    PARASITES NIL) */
