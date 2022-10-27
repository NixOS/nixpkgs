/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "classowary";
  version = "20191007-git";

  description = "An implementation of the Cassowary linear constraint solver toolkit";

  deps = [ args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/classowary/2019-10-07/classowary-20191007-git.tgz";
    sha256 = "1r3535lgap7218v51k5rn2wlml4mlam3sgjg1lvac1vybiv4c287";
  };

  packageName = "classowary";

  asdFilesToKeep = ["classowary.asd"];
  overrides = x: x;
}
/* (SYSTEM classowary DESCRIPTION
    An implementation of the Cassowary linear constraint solver toolkit SHA256
    1r3535lgap7218v51k5rn2wlml4mlam3sgjg1lvac1vybiv4c287 URL
    http://beta.quicklisp.org/archive/classowary/2019-10-07/classowary-20191007-git.tgz
    MD5 a2587986780a40251b0327686b817cc6 NAME classowary FILENAME classowary
    DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils trivial-indent) VERSION 20191007-git
    SIBLINGS (classowary-test) PARASITES NIL) */
