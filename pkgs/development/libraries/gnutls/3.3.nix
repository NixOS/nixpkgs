{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.16";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.lz";
    sha256 = "1jl5n02mh83ygrrk7rq8vwylv5gdr3wccqs1ynvzr749fd2wq637";
  };
})
