/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre-template";
  version = "cl-unification-20211230-git";

  description = "A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.";

  deps = [ args."cl-ppcre" args."cl-unification" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-unification/2021-12-30/cl-unification-20211230-git.tgz";
    sha256 = "1gf961ihdmn8k805r5bg4kj802nazz9gxs462isibkxjjc7sjlsl";
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
    SHA256 1gf961ihdmn8k805r5bg4kj802nazz9gxs462isibkxjjc7sjlsl URL
    http://beta.quicklisp.org/archive/cl-unification/2021-12-30/cl-unification-20211230-git.tgz
    MD5 7be56c62289bb8db07a8caaea4102ac4 NAME cl-ppcre-template FILENAME
    cl-ppcre-template DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unification FILENAME cl-unification))
    DEPENDENCIES (cl-ppcre cl-unification) VERSION cl-unification-20211230-git
    SIBLINGS (cl-unification-lib cl-unification-test cl-unification) PARASITES
    NIL) */
