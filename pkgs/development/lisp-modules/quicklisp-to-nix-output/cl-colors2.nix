/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-colors2";
  version = "20210630-git";

  description = "Simple color library for Common Lisp";

  deps = [ args."alexandria" args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-colors2/2021-06-30/cl-colors2-20210630-git.tgz";
    sha256 = "00mb239p4r30fm7b0qwfg1vfyp83h2h87igk3hqqgvadp6infi7g";
  };

  packageName = "cl-colors2";

  asdFilesToKeep = ["cl-colors2.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors2 DESCRIPTION Simple color library for Common Lisp SHA256
    00mb239p4r30fm7b0qwfg1vfyp83h2h87igk3hqqgvadp6infi7g URL
    http://beta.quicklisp.org/archive/cl-colors2/2021-06-30/cl-colors2-20210630-git.tgz
    MD5 50a5885e2b55239d5904b0a0134e0be3 NAME cl-colors2 FILENAME cl-colors2
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre))
    DEPENDENCIES (alexandria cl-ppcre) VERSION 20210630-git SIBLINGS NIL
    PARASITES NIL) */
