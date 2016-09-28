{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.3";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "92c4bc999a10a1b95299ebefaeea8333f19d8a98d957a35b5eae74881bdb1fef";
  };
})
