/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-reexport";
  version = "20210228-git";

  description = "Reexport external symbols in other packages.";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-reexport/2021-02-28/cl-reexport-20210228-git.tgz";
    sha256 = "1ay0ng5nnbq200g4wxs0h7byx24za4yk208nhfsmksahk5qj1qra";
  };

  packageName = "cl-reexport";

  asdFilesToKeep = ["cl-reexport.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-reexport DESCRIPTION Reexport external symbols in other packages.
    SHA256 1ay0ng5nnbq200g4wxs0h7byx24za4yk208nhfsmksahk5qj1qra URL
    http://beta.quicklisp.org/archive/cl-reexport/2021-02-28/cl-reexport-20210228-git.tgz
    MD5 e083a9c49fe39d65f1ff7743eebe37c2 NAME cl-reexport FILENAME cl-reexport
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria)
    VERSION 20210228-git SIBLINGS (cl-reexport-test) PARASITES NIL) */
