{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.16";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "09rrjaflgp5p0hi5gqljklz1xpalnvj8bawvjj6baw8768dvp6nr";
  };
})
