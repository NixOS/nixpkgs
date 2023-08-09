/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "jsown";
  version = "20200218-git";

  description = "Fast JSON parsing library.  Mainly geared torwards fetching only a few keys of many objects, but efficient for other types of content too";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/jsown/2020-02-18/jsown-20200218-git.tgz";
    sha256 = "10cn1fkznyq73vxwy95wsd36yfiiakmk278lv7mzzsyqc1jrn2hj";
  };

  packageName = "jsown";

  asdFilesToKeep = ["jsown.asd"];
  overrides = x: x;
}
/* (SYSTEM jsown DESCRIPTION
    Fast JSON parsing library.  Mainly geared torwards fetching only a few keys of many objects, but efficient for other types of content too
    SHA256 10cn1fkznyq73vxwy95wsd36yfiiakmk278lv7mzzsyqc1jrn2hj URL
    http://beta.quicklisp.org/archive/jsown/2020-02-18/jsown-20200218-git.tgz
    MD5 ecf8bfcc2a2ccbab9baddca6592b34ba NAME jsown FILENAME jsown DEPS NIL
    DEPENDENCIES NIL VERSION 20200218-git SIBLINGS (jsown-tests) PARASITES NIL) */
