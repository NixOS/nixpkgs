{stdenv, fetchurl, unzip}:

import ./generic.nix {
  inherit stdenv fetchurl unzip;
  name = "docbook-xml-4.5";
  src = fetchurl {
    url = http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip;
    sha256 = "1d671lcjckjri28xfbf6dq7y3xnkppa910w1jin8rjc35dx06kjf";
  };
}
