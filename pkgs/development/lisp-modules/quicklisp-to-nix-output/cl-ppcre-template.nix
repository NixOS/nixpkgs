args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-template'';
  version = ''cl-unification-20190107-git'';

  description = ''A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.'';

  deps = [ args."cl-ppcre" args."cl-unification" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2019-01-07/cl-unification-20190107-git.tgz'';
    sha256 = ''0mp40wh58afnpqx9i9wg5x364g35rkd6c9d5hb9g6pdxadqx0cfv'';
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
    SHA256 0mp40wh58afnpqx9i9wg5x364g35rkd6c9d5hb9g6pdxadqx0cfv URL
    http://beta.quicklisp.org/archive/cl-unification/2019-01-07/cl-unification-20190107-git.tgz
    MD5 a7a12789cc48e571b0871d55cef11b7f NAME cl-ppcre-template FILENAME
    cl-ppcre-template DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unification FILENAME cl-unification))
    DEPENDENCIES (cl-ppcre cl-unification) VERSION cl-unification-20190107-git
    SIBLINGS (cl-unification-lib cl-unification-test cl-unification) PARASITES
    NIL) */
