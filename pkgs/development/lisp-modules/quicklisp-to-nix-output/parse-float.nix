/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parse-float";
  version = "20200218-git";

  parasites = [ "parse-float-tests" ];

  description = "Parse floating point values in strings.";

  deps = [ args."alexandria" args."lisp-unit" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parse-float/2020-02-18/parse-float-20200218-git.tgz";
    sha256 = "02rhgn79hhv0p5ysj4gwk5bhmr2sj6cvkacbqzzw24qrzgcpdnfw";
  };

  packageName = "parse-float";

  asdFilesToKeep = ["parse-float.asd"];
  overrides = x: x;
}
/* (SYSTEM parse-float DESCRIPTION Parse floating point values in strings.
    SHA256 02rhgn79hhv0p5ysj4gwk5bhmr2sj6cvkacbqzzw24qrzgcpdnfw URL
    http://beta.quicklisp.org/archive/parse-float/2020-02-18/parse-float-20200218-git.tgz
    MD5 149e40a8c5fd6ab0e43242cb898d66bf NAME parse-float FILENAME parse-float
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME lisp-unit FILENAME lisp-unit))
    DEPENDENCIES (alexandria lisp-unit) VERSION 20200218-git SIBLINGS NIL
    PARASITES (parse-float-tests)) */
