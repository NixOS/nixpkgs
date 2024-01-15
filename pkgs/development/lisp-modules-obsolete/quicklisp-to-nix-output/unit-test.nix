/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "unit-test";
  version = "20120520-git";

  description = "unit-testing framework for common lisp";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/unit-test/2012-05-20/unit-test-20120520-git.tgz";
    sha256 = "1bwbx9d2z9qll46ksfh7bgd0dgh4is2dyfhkladq53qycvjywv9l";
  };

  packageName = "unit-test";

  asdFilesToKeep = ["unit-test.asd"];
  overrides = x: x;
}
/* (SYSTEM unit-test DESCRIPTION unit-testing framework for common lisp SHA256
    1bwbx9d2z9qll46ksfh7bgd0dgh4is2dyfhkladq53qycvjywv9l URL
    http://beta.quicklisp.org/archive/unit-test/2012-05-20/unit-test-20120520-git.tgz
    MD5 ffcde1c03dd33862cd4f7288649c3cbc NAME unit-test FILENAME unit-test DEPS
    NIL DEPENDENCIES NIL VERSION 20120520-git SIBLINGS NIL PARASITES NIL) */
