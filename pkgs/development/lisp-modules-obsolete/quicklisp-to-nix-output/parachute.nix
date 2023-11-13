/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parachute";
  version = "20211020-git";

  description = "An extensible and cross-compatible testing framework.";

  deps = [ args."documentation-utils" args."form-fiddle" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parachute/2021-10-20/parachute-20211020-git.tgz";
    sha256 = "1sc63a6z3zwdsc9h3w0dbx7yssvg2zzdyhh81kqc5cx17vcdqyk0";
  };

  packageName = "parachute";

  asdFilesToKeep = ["parachute.asd"];
  overrides = x: x;
}
/* (SYSTEM parachute DESCRIPTION
    An extensible and cross-compatible testing framework. SHA256
    1sc63a6z3zwdsc9h3w0dbx7yssvg2zzdyhh81kqc5cx17vcdqyk0 URL
    http://beta.quicklisp.org/archive/parachute/2021-10-20/parachute-20211020-git.tgz
    MD5 85eba816a1e7a43a154e6a1544e15e52 NAME parachute FILENAME parachute DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils form-fiddle trivial-indent) VERSION
    20211020-git SIBLINGS
    (parachute-fiveam parachute-lisp-unit parachute-prove) PARASITES NIL) */
