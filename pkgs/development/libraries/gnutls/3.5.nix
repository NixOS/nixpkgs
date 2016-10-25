{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.5";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "0ag5q3dfxzv0dmqy7q0a8y74yc3m5yzvjrp324l6vqafh3klz6c6";
  };
})
