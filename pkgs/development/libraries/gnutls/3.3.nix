{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.24";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.xz";
    sha256 = "5b65fe2a91c8dfa32bedc78acffcb152e5426cd3349e2afc43cccc9bdaf18aa5";
  };
})
