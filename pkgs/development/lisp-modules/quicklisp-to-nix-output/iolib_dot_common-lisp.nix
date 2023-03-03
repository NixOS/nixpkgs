/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_common-lisp";
  version = "iolib-v0.8.4";

  description = "Slightly modified Common Lisp.";

  deps = [ args."alexandria" args."iolib_dot_asdf" args."iolib_dot_conf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz";
    sha256 = "0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq";
  };

  packageName = "iolib.common-lisp";

  asdFilesToKeep = ["iolib.common-lisp.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.common-lisp DESCRIPTION Slightly modified Common Lisp. SHA256
    0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq URL
    http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz MD5
    5650165890f8b278b357864f597b377d NAME iolib.common-lisp FILENAME
    iolib_dot_common-lisp DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.conf FILENAME iolib_dot_conf))
    DEPENDENCIES (alexandria iolib.asdf iolib.conf) VERSION iolib-v0.8.4
    SIBLINGS (iolib iolib.asdf iolib.base iolib.conf iolib.examples) PARASITES
    NIL) */
