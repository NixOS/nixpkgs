{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.2";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.lz";
    sha256 = "1wzasbrs4ncq4yisqyvifl7mzlyyg1pb0idr4fhjmcfpi13sxlaw";
  };
})
