args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-template'';
  version = ''cl-unification-20170630-git'';

  description = ''A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.'';

  deps = [ args."cl-ppcre" args."cl-unification" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz'';
    sha256 = ''063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz'';
  };

  packageName = "cl-ppcre-template";

  asdFilesToKeep = ["cl-ppcre-template.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-template DESCRIPTION
    A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.
    SHA256 063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz URL
    http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz
    MD5 f6bf197ca8c79c935efe3a3c25953044 NAME cl-ppcre-template FILENAME
    cl-ppcre-template DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unification FILENAME cl-unification))
    DEPENDENCIES (cl-ppcre cl-unification) VERSION cl-unification-20170630-git
    SIBLINGS (cl-unification-lib cl-unification-test cl-unification) PARASITES
    NIL) */
