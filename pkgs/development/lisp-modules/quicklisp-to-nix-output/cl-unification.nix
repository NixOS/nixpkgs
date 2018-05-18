args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unification'';
  version = ''20171227-git'';

  description = ''The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-12-27/cl-unification-20171227-git.tgz'';
    sha256 = ''0shwnvn5zf0iwgyqf3pa1b9cv2xghl7pss1ymrjgs95r6ijqxn2p'';
  };

  packageName = "cl-unification";

  asdFilesToKeep = ["cl-unification.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 0shwnvn5zf0iwgyqf3pa1b9cv2xghl7pss1ymrjgs95r6ijqxn2p URL
    http://beta.quicklisp.org/archive/cl-unification/2017-12-27/cl-unification-20171227-git.tgz
    MD5 45bfd18f8e15d16222e0f747992a6ce6 NAME cl-unification FILENAME
    cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20171227-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template) PARASITES NIL) */
