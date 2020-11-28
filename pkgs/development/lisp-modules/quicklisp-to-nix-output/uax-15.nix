args @ { fetchurl, ... }:
rec {
  baseName = ''uax-15'';
  version = ''20200325-git'';

  parasites = [ "uax-15/tests" ];

  description = ''Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)'';

  deps = [ args."cl-ppcre" args."fiveam" args."split-sequence" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uax-15/2020-03-25/uax-15-20200325-git.tgz'';
    sha256 = ''0nld8a95fy0nfni8g663786cz5q3x63bxymx0jlaknb6lfibb6pc'';
  };

  packageName = "uax-15";

  asdFilesToKeep = ["uax-15.asd"];
  overrides = x: x;
}
/* (SYSTEM uax-15 DESCRIPTION
    Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)
    SHA256 0nld8a95fy0nfni8g663786cz5q3x63bxymx0jlaknb6lfibb6pc URL
    http://beta.quicklisp.org/archive/uax-15/2020-03-25/uax-15-20200325-git.tgz
    MD5 95b8883fa0e85189f701a40c292b8828 NAME uax-15 FILENAME uax-15 DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME fiveam FILENAME fiveam)
     (NAME split-sequence FILENAME split-sequence) (NAME uiop FILENAME uiop))
    DEPENDENCIES (cl-ppcre fiveam split-sequence uiop) VERSION 20200325-git
    SIBLINGS NIL PARASITES (uax-15/tests)) */
