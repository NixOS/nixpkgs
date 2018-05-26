args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-template'';
  version = ''cl-unification-20171227-git'';

  description = ''A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.'';

  deps = [ args."cl-ppcre" args."cl-unification" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-12-27/cl-unification-20171227-git.tgz'';
    sha256 = ''0shwnvn5zf0iwgyqf3pa1b9cv2xghl7pss1ymrjgs95r6ijqxn2p'';
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
    SHA256 0shwnvn5zf0iwgyqf3pa1b9cv2xghl7pss1ymrjgs95r6ijqxn2p URL
    http://beta.quicklisp.org/archive/cl-unification/2017-12-27/cl-unification-20171227-git.tgz
    MD5 45bfd18f8e15d16222e0f747992a6ce6 NAME cl-ppcre-template FILENAME
    cl-ppcre-template DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unification FILENAME cl-unification))
    DEPENDENCIES (cl-ppcre cl-unification) VERSION cl-unification-20171227-git
    SIBLINGS (cl-unification-lib cl-unification-test cl-unification) PARASITES
    NIL) */
