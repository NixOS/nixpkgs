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
  version = "4.3";
  hash = "sha256-IwaKlOpv1ISwBMWnPsNqZqpH6o8Na2LMFpWTH1wUNGQ=";
}
