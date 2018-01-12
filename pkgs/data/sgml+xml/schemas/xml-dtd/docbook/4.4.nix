{stdenv, fetchurl, unzip, findXMLCatalogs}:

import ./generic.nix {
  inherit stdenv fetchurl unzip findXMLCatalogs;
  name = "docbook-xml-4.4";
  src = fetchurl {
    url = http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip;
    sha256 = "141h4zsyc71sfi2zzd89v4bb4qqq9ca1ri9ix2als9f4i3mmkw82";
  };
  meta = {
    branch = "4.4";
  };
}
