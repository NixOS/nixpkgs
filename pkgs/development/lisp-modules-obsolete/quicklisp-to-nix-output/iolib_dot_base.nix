/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_base";
  version = "iolib-v0.8.4";

  description = "Base IOlib package, used instead of CL.";

  deps = [ args."alexandria" args."iolib_dot_asdf" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz";
    sha256 = "0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq";
  };

  packageName = "iolib.base";

  asdFilesToKeep = ["iolib.base.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.base DESCRIPTION Base IOlib package, used instead of CL.
    SHA256 0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq URL
    http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz MD5
    5650165890f8b278b357864f597b377d NAME iolib.base FILENAME iolib_dot_base
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES
    (alexandria iolib.asdf iolib.common-lisp iolib.conf split-sequence) VERSION
    iolib-v0.8.4 SIBLINGS
    (iolib iolib.asdf iolib.common-lisp iolib.conf iolib.examples) PARASITES
    NIL) */
