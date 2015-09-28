{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.18";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.xz";
    sha256 = "15ckyblhkap3d4sqw0dc9l8wdrnd2aj1fs9m0w0a3bfihvsfg1vs";
  };
})
