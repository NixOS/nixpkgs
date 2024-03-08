/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-unification";
  version = "20200925-git";

  description = "The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-unification/2020-09-25/cl-unification-20200925-git.tgz";
    sha256 = "05i1bmbabfgym9v28cbl37yr0r1m4a4k4a844z6wlq6qf45vzais";
  };

  packageName = "cl-unification";

  asdFilesToKeep = ["cl-unification.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 05i1bmbabfgym9v28cbl37yr0r1m4a4k4a844z6wlq6qf45vzais URL
    http://beta.quicklisp.org/archive/cl-unification/2020-09-25/cl-unification-20200925-git.tgz
    MD5 90588d566c2e12dac3530b65384a87ab NAME cl-unification FILENAME
    cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template) PARASITES NIL) */
