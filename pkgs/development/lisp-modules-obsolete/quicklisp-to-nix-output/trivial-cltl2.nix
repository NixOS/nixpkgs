/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-cltl2";
  version = "20200325-git";

  description = "Compatibility package exporting CLtL2 functionality";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-cltl2/2020-03-25/trivial-cltl2-20200325-git.tgz";
    sha256 = "0hahi36v47alsvamg62d0cgay8l0razcgxl089ifj6sqy7s8iwys";
  };

  packageName = "trivial-cltl2";

  asdFilesToKeep = ["trivial-cltl2.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-cltl2 DESCRIPTION
    Compatibility package exporting CLtL2 functionality SHA256
    0hahi36v47alsvamg62d0cgay8l0razcgxl089ifj6sqy7s8iwys URL
    http://beta.quicklisp.org/archive/trivial-cltl2/2020-03-25/trivial-cltl2-20200325-git.tgz
    MD5 aa18140b9840365ceb9a6cddbdbdd67b NAME trivial-cltl2 FILENAME
    trivial-cltl2 DEPS NIL DEPENDENCIES NIL VERSION 20200325-git SIBLINGS NIL
    PARASITES NIL) */
