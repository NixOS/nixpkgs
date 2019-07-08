args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unification'';
  version = ''20190107-git'';

  description = ''The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2019-01-07/cl-unification-20190107-git.tgz'';
    sha256 = ''0mp40wh58afnpqx9i9wg5x364g35rkd6c9d5hb9g6pdxadqx0cfv'';
  };

  packageName = "cl-unification";

  asdFilesToKeep = ["cl-unification.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 0mp40wh58afnpqx9i9wg5x364g35rkd6c9d5hb9g6pdxadqx0cfv URL
    http://beta.quicklisp.org/archive/cl-unification/2019-01-07/cl-unification-20190107-git.tgz
    MD5 a7a12789cc48e571b0871d55cef11b7f NAME cl-unification FILENAME
    cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20190107-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template) PARASITES NIL) */
