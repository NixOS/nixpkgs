/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_conf";
  version = "iolib-v0.8.4";

  description = "Compile-time configuration for IOLib.";

  deps = [ args."alexandria" args."iolib_dot_asdf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz";
    sha256 = "0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq";
  };

  packageName = "iolib.conf";

  asdFilesToKeep = ["iolib.conf.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.conf DESCRIPTION Compile-time configuration for IOLib. SHA256
    0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq URL
    http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz MD5
    5650165890f8b278b357864f597b377d NAME iolib.conf FILENAME iolib_dot_conf
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf))
    DEPENDENCIES (alexandria iolib.asdf) VERSION iolib-v0.8.4 SIBLINGS
    (iolib iolib.asdf iolib.base iolib.common-lisp iolib.examples) PARASITES
    NIL) */
