/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-cltl2";
  version = "20211230-git";

  description = "Compatibility package exporting CLtL2 functionality";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-cltl2/2021-12-30/trivial-cltl2-20211230-git.tgz";
    sha256 = "0ixds4vjvfy8z7z8pffbgxglk4wj3pkp4rv7vlks11pi42ys8ry4";
  };

  packageName = "trivial-cltl2";

  asdFilesToKeep = ["trivial-cltl2.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-cltl2 DESCRIPTION
    Compatibility package exporting CLtL2 functionality SHA256
    0ixds4vjvfy8z7z8pffbgxglk4wj3pkp4rv7vlks11pi42ys8ry4 URL
    http://beta.quicklisp.org/archive/trivial-cltl2/2021-12-30/trivial-cltl2-20211230-git.tgz
    MD5 1724626b5c6081d9d8860640166c69a7 NAME trivial-cltl2 FILENAME
    trivial-cltl2 DEPS NIL DEPENDENCIES NIL VERSION 20211230-git SIBLINGS NIL
    PARASITES NIL) */
