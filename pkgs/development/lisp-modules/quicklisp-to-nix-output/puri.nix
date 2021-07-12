/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "puri";
  version = "20201016-git";

  parasites = [ "puri/test" ];

  description = "Portable Universal Resource Indentifier Library";

  deps = [ args."ptester" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/puri/2020-10-16/puri-20201016-git.tgz";
    sha256 = "16h7gip6d0564s9yba3jg0rjzndmysv531hcrngvi3j3sandjfzx";
  };

  packageName = "puri";

  asdFilesToKeep = ["puri.asd"];
  overrides = x: x;
}
/* (SYSTEM puri DESCRIPTION Portable Universal Resource Indentifier Library
    SHA256 16h7gip6d0564s9yba3jg0rjzndmysv531hcrngvi3j3sandjfzx URL
    http://beta.quicklisp.org/archive/puri/2020-10-16/puri-20201016-git.tgz MD5
    890c61df1d7204b2d681bf146c43e711 NAME puri FILENAME puri DEPS
    ((NAME ptester FILENAME ptester)) DEPENDENCIES (ptester) VERSION
    20201016-git SIBLINGS NIL PARASITES (puri/test)) */
