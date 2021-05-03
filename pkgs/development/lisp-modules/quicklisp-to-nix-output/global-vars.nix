/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "global-vars";
  version = "20141106-git";

  description = "Define efficient global variables.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/global-vars/2014-11-06/global-vars-20141106-git.tgz";
    sha256 = "0bjgmsifs9vrq409rfrsgrhlxwklvls1dpvh2d706i0incxq957j";
  };

  packageName = "global-vars";

  asdFilesToKeep = ["global-vars.asd"];
  overrides = x: x;
}
/* (SYSTEM global-vars DESCRIPTION Define efficient global variables. SHA256
    0bjgmsifs9vrq409rfrsgrhlxwklvls1dpvh2d706i0incxq957j URL
    http://beta.quicklisp.org/archive/global-vars/2014-11-06/global-vars-20141106-git.tgz
    MD5 dd3153ee75c972a80450aa00644b2200 NAME global-vars FILENAME global-vars
    DEPS NIL DEPENDENCIES NIL VERSION 20141106-git SIBLINGS (global-vars-test)
    PARASITES NIL) */
