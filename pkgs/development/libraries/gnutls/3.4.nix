{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.4";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.lz";
    sha256 = "17xazr0fdhlkr13bwiy52xq6z6mssml7q1ydyj8s1hwh68703c75";
  };
})
