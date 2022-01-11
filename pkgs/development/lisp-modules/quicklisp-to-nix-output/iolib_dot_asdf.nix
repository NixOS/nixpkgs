/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib_dot_asdf";
  version = "iolib-v0.8.4";

  description = "A few ASDF component classes.";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz";
    sha256 = "0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq";
  };

  packageName = "iolib.asdf";

  asdFilesToKeep = ["iolib.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.asdf DESCRIPTION A few ASDF component classes. SHA256
    0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq URL
    http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz MD5
    5650165890f8b278b357864f597b377d NAME iolib.asdf FILENAME iolib_dot_asdf
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria)
    VERSION iolib-v0.8.4 SIBLINGS
    (iolib iolib.base iolib.common-lisp iolib.conf iolib.examples) PARASITES
    NIL) */
