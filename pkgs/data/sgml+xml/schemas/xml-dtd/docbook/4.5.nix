{
  lib,
  stdenv,
  fetchurl,
  unzip,
  findXMLCatalogs,
}:

import ./generic.nix {
  inherit
    lib
    stdenv
    fetchurl
    unzip
    findXMLCatalogs
    ;
  version = "4.5";
  hash = "sha256-Tk4DeiuDyYxslIGDkNS90/bhD27GLdeRiFlOJhkNx7Q=";
}
