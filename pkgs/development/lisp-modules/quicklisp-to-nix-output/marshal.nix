/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "marshal";
  version = "cl-20210411-git";

  description = "marshal: Simple (de)serialization of Lisp datastructures.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-marshal/2021-04-11/cl-marshal-20210411-git.tgz";
    sha256 = "0wi4csgl5qxgl0si5mcg19xx4qlmw125qn0w1i2f3dvvrzp20qrp";
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    0wi4csgl5qxgl0si5mcg19xx4qlmw125qn0w1i2f3dvvrzp20qrp URL
    http://beta.quicklisp.org/archive/cl-marshal/2021-04-11/cl-marshal-20210411-git.tgz
    MD5 2463314a6bcd1a18bea2690deb6bce55 NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20210411-git SIBLINGS (marshal-tests) PARASITES
    NIL) */
