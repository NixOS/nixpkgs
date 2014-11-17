{stdenv, fetchurl, unzip}:

import ./generic.nix {
  inherit stdenv fetchurl unzip;
  name = "docbook-xml-4.2";
  src = fetchurl {
    url = http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip;
    md5 = "73fe50dfe74ca631c1602f558ed8961f";
  };
  meta = {
    branch = "4.2";
  };
}
