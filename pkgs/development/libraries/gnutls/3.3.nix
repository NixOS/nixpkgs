{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.17";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.lz";
    sha256 = "00zrwqvy054fymb6j04xfr583javfjxsid2rbmyk63qrbqzm61v7";
  };
})
