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
  version = "4.2";
  hash = "sha256-rMRgHk+XoZYHa35ks2jZJIsHx6vyazSgLMpA7uvmD6I=";
}
