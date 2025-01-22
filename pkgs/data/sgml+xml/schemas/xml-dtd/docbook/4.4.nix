{lib, stdenv, fetchurl, unzip, findXMLCatalogs}:

import ./generic.nix {
  inherit lib stdenv unzip findXMLCatalogs;
  version = "4.4";
  src = fetchurl {
    url = "https://docbook.org/xml/4.4/docbook-xml-4.4.zip";
    sha256 = "141h4zsyc71sfi2zzd89v4bb4qqq9ca1ri9ix2als9f4i3mmkw82";
  };
}
