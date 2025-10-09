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
    unzip
    findXMLCatalogs
    ;
  version = "4.2";
  src = fetchurl {
    url = "https://docbook.org/xml/4.2/docbook-xml-4.2.zip";
    sha256 = "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2";
  };
}
