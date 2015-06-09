{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.1";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.lz";
    sha256 = "06wiwsydfpy5fn86ip4x2s507483l4y847kr1p2chgjw0wqc8vjy";
  };
})
