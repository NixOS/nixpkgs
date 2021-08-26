/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uax-15";
  version = "20210228-git";

  parasites = [ "uax-15/tests" ];

  description = "Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)";

  deps = [ args."cl-ppcre" args."fiveam" args."split-sequence" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uax-15/2021-02-28/uax-15-20210228-git.tgz";
    sha256 = "1vf590djzyika6200zqw4mbqrajcmv7g5swydimnvk7xqzpa8ksp";
  };

  packageName = "uax-15";

  asdFilesToKeep = ["uax-15.asd"];
  overrides = x: x;
}
/* (SYSTEM uax-15 DESCRIPTION
    Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)
    SHA256 1vf590djzyika6200zqw4mbqrajcmv7g5swydimnvk7xqzpa8ksp URL
    http://beta.quicklisp.org/archive/uax-15/2021-02-28/uax-15-20210228-git.tgz
    MD5 b801b3b91cdd57cecf086f1fe5fb31d6 NAME uax-15 FILENAME uax-15 DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME fiveam FILENAME fiveam)
     (NAME split-sequence FILENAME split-sequence) (NAME uiop FILENAME uiop))
    DEPENDENCIES (cl-ppcre fiveam split-sequence uiop) VERSION 20210228-git
    SIBLINGS NIL PARASITES (uax-15/tests)) */
