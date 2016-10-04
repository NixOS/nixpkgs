{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.4";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "1sx8p7v452s9m854r2c5pvcd1k15a3caiv5h35fhrxz0691h2f2f";
  };
})
