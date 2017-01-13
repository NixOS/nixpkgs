{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.26";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.xz";
    sha256 = "1n90qyz54hhnmf4fmap6zdyv7nihz6mrbqgxhd46h7aqdcmqhzba";
  };
})
