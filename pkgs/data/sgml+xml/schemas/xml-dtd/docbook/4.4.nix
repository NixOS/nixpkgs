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
  version = "4.4";
  hash = "sha256-AvFZ64jEJU2V6DHFHBRLGGOyFtkJtf9FdDoc5vUnMJA=";
}
