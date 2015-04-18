{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.2.21";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-${version}.tar.lz";
    sha256 = "1xydzlwmf0frxvr26yw0ily5vwkdvf90m53fix61bi5gx4xd2m7m";
  };
})
