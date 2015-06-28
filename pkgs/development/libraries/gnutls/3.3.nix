{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.15";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.lz";
    sha256 = "166nynb055vlh6dm1gaqwpcnf4mp7ks8lz2yvm7dlsrkbh3swj5m";
  };
})
