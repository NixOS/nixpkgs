{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.25";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.xz";
    sha256 = "0bhzkzpzwg3lhbhpas7m4rcj4mrnyq76zmic9z42wpa68d76r78q";
  };
})
