/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre-template";
  version = "cl-unification-20200925-git";

  description = "A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.";

  deps = [ args."cl-ppcre" args."cl-unification" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-unification/2020-09-25/cl-unification-20200925-git.tgz";
    sha256 = "05i1bmbabfgym9v28cbl37yr0r1m4a4k4a844z6wlq6qf45vzais";
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
    SHA256 05i1bmbabfgym9v28cbl37yr0r1m4a4k4a844z6wlq6qf45vzais URL
    http://beta.quicklisp.org/archive/cl-unification/2020-09-25/cl-unification-20200925-git.tgz
    MD5 90588d566c2e12dac3530b65384a87ab NAME cl-ppcre-template FILENAME
    cl-ppcre-template DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unification FILENAME cl-unification))
    DEPENDENCIES (cl-ppcre cl-unification) VERSION cl-unification-20200925-git
    SIBLINGS (cl-unification-lib cl-unification-test cl-unification) PARASITES
    NIL) */
