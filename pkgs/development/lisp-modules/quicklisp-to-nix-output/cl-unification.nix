/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-unification";
  version = "20211230-git";

  description = "The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-unification/2021-12-30/cl-unification-20211230-git.tgz";
    sha256 = "1gf961ihdmn8k805r5bg4kj802nazz9gxs462isibkxjjc7sjlsl";
  };

  packageName = "cl-unification";

  asdFilesToKeep = ["cl-unification.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 1gf961ihdmn8k805r5bg4kj802nazz9gxs462isibkxjjc7sjlsl URL
    http://beta.quicklisp.org/archive/cl-unification/2021-12-30/cl-unification-20211230-git.tgz
    MD5 7be56c62289bb8db07a8caaea4102ac4 NAME cl-unification FILENAME
    cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20211230-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template) PARASITES NIL) */
