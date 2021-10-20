/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parachute";
  version = "20210807-git";

  description = "An extensible and cross-compatible testing framework.";

  deps = [ args."documentation-utils" args."form-fiddle" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parachute/2021-08-07/parachute-20210807-git.tgz";
    sha256 = "0h20f73781qpylhs3v0gywzz3iwkxh1bksl7d674dxdl988ngzbs";
  };

  packageName = "parachute";

  asdFilesToKeep = ["parachute.asd"];
  overrides = x: x;
}
/* (SYSTEM parachute DESCRIPTION
    An extensible and cross-compatible testing framework. SHA256
    0h20f73781qpylhs3v0gywzz3iwkxh1bksl7d674dxdl988ngzbs URL
    http://beta.quicklisp.org/archive/parachute/2021-08-07/parachute-20210807-git.tgz
    MD5 3a25227cffef9f2d9947750490d643ec NAME parachute FILENAME parachute DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils form-fiddle trivial-indent) VERSION
    20210807-git SIBLINGS
    (parachute-fiveam parachute-lisp-unit parachute-prove) PARASITES NIL) */
