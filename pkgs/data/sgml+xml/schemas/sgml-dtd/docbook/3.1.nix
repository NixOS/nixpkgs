{ fetchurl
, callPackage
}:

callPackage ./common.nix {
  version = "3.1";

  src = fetchurl {
    url = "http://www.oasis-open.org/docbook/sgml/3.1/docbk31.zip";
    sha256 = "0f25ch7bywwhdxb1qa0hl28mgq1blqdap3rxzamm585rf4kis9i0";
  };
}
