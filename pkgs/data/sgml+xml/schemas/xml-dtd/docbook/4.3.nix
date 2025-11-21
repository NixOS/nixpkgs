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
  version = "4.3";
  src = fetchurl {
    url = "https://docbook.org/xml/4.3/docbook-xml-4.3.zip";
    sha256 = "0r1l2if1z4wm2v664sqdizm4gak6db1kx9y50jq89m3gxaa8l1i3";
  };
}
