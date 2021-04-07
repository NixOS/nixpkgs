/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "named-readtables";
  version = "20210124-git";

  parasites = [ "named-readtables/test" ];

  description = "Library that creates a namespace for named readtable
  akin to the namespace of packages.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/named-readtables/2021-01-24/named-readtables-20210124-git.tgz";
    sha256 = "00lbcv1qdb9ldq2kbf1rkn5sh657px9dgqrcynbwjzvla4czadl4";
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for named readtable
  akin to the namespace of packages.
    SHA256 00lbcv1qdb9ldq2kbf1rkn5sh657px9dgqrcynbwjzvla4czadl4 URL
    http://beta.quicklisp.org/archive/named-readtables/2021-01-24/named-readtables-20210124-git.tgz
    MD5 a4f2ae5f9715ec2c42cd164d15a0c918 NAME named-readtables FILENAME
    named-readtables DEPS NIL DEPENDENCIES NIL VERSION 20210124-git SIBLINGS
    NIL PARASITES (named-readtables/test)) */
