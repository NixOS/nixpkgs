{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.14";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "35deddf2779b76ac11057de38bf380b8066c05de21b94263ad5b6dfa75dfbb23";
  };
})
