/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clunit2";
  version = "20201016-git";

  description = "CLUnit is a Common Lisp unit testing framework.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clunit2/2020-10-16/clunit2-20201016-git.tgz";
    sha256 = "1mj3c125drq9a3pxrh0r8q3gqgq68yk7qi0zbqh4mkpavl1aspdp";
  };

  packageName = "clunit2";

  asdFilesToKeep = ["clunit2.asd"];
  overrides = x: x;
}
/* (SYSTEM clunit2 DESCRIPTION CLUnit is a Common Lisp unit testing framework.
    SHA256 1mj3c125drq9a3pxrh0r8q3gqgq68yk7qi0zbqh4mkpavl1aspdp URL
    http://beta.quicklisp.org/archive/clunit2/2020-10-16/clunit2-20201016-git.tgz
    MD5 7f977b33550c689d1d2cf2c8a4610896 NAME clunit2 FILENAME clunit2 DEPS NIL
    DEPENDENCIES NIL VERSION 20201016-git SIBLINGS NIL PARASITES NIL) */
