/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date-time";
  version = "20160421-git";

  description = "date and time library for common lisp";

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/simple-date-time/2016-04-21/simple-date-time-20160421-git.tgz";
    sha256 = "1db9n7pspxkqkzz12829a1lp7v4ghrnlb7g3wh04yz6m224d3i4h";
  };

  packageName = "simple-date-time";

  asdFilesToKeep = ["simple-date-time.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date-time DESCRIPTION date and time library for common lisp
    SHA256 1db9n7pspxkqkzz12829a1lp7v4ghrnlb7g3wh04yz6m224d3i4h URL
    http://beta.quicklisp.org/archive/simple-date-time/2016-04-21/simple-date-time-20160421-git.tgz
    MD5 a5b1e4af539646723dafacbc8cf732a0 NAME simple-date-time FILENAME
    simple-date-time DEPS ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES
    (cl-ppcre) VERSION 20160421-git SIBLINGS NIL PARASITES NIL) */
