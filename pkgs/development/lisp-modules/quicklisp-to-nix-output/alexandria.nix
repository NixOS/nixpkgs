/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "alexandria";
  version = "20210411-git";

  description = "Alexandria is a collection of portable public domain utilities.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/alexandria/2021-04-11/alexandria-20210411-git.tgz";
    sha256 = "0bd4axr1z1q6khvpyf5xvgybdajs1dc7my6g0rdzhhxbibfcf3yh";
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    0bd4axr1z1q6khvpyf5xvgybdajs1dc7my6g0rdzhhxbibfcf3yh URL
    http://beta.quicklisp.org/archive/alexandria/2021-04-11/alexandria-20210411-git.tgz
    MD5 415c43451862b490577b20ee4fb8e8d7 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20210411-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
