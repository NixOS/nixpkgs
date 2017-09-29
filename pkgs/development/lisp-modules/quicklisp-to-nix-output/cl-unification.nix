args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unification'';
  version = ''20170630-git'';

  description = ''The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz'';
    sha256 = ''063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz'';
  };

  packageName = "cl-unification";

  asdFilesToKeep = ["cl-unification.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz URL
    http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz
    MD5 f6bf197ca8c79c935efe3a3c25953044 NAME cl-unification FILENAME
    cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template) PARASITES NIL) */
