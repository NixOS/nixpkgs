/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-unicode";
  version = "20210228-git";

  parasites = [ "cl-unicode/base" "cl-unicode/build" "cl-unicode/test" ];

  description = "Portable Unicode Library";

  deps = [ args."cl-ppcre" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-unicode/2021-02-28/cl-unicode-20210228-git.tgz";
    sha256 = "0phy5wppb7m78dixrf2vjq8vas4drfd4qg38al6q8ymkl0yfy5js";
  };

  packageName = "cl-unicode";

  asdFilesToKeep = ["cl-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256
    0phy5wppb7m78dixrf2vjq8vas4drfd4qg38al6q8ymkl0yfy5js URL
    http://beta.quicklisp.org/archive/cl-unicode/2021-02-28/cl-unicode-20210228-git.tgz
    MD5 5b3bdddde3be5b8427e3fac92495a10b NAME cl-unicode FILENAME cl-unicode
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre flexi-streams) VERSION 20210228-git SIBLINGS NIL
    PARASITES (cl-unicode/base cl-unicode/build cl-unicode/test)) */
