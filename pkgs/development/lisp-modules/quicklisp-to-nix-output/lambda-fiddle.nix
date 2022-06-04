/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lambda-fiddle";
  version = "20211020-git";

  description = "A collection of functions to process lambda-lists.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lambda-fiddle/2021-10-20/lambda-fiddle-20211020-git.tgz";
    sha256 = "13v1dcwd40qavy1y6p9h10v4xvzq347fjqq8jbhbbpb337ch1syq";
  };

  packageName = "lambda-fiddle";

  asdFilesToKeep = ["lambda-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM lambda-fiddle DESCRIPTION
    A collection of functions to process lambda-lists. SHA256
    13v1dcwd40qavy1y6p9h10v4xvzq347fjqq8jbhbbpb337ch1syq URL
    http://beta.quicklisp.org/archive/lambda-fiddle/2021-10-20/lambda-fiddle-20211020-git.tgz
    MD5 89c1c5a2066775e728e4b8051f67d932 NAME lambda-fiddle FILENAME
    lambda-fiddle DEPS NIL DEPENDENCIES NIL VERSION 20211020-git SIBLINGS NIL
    PARASITES NIL) */
