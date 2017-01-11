{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.17";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "0bhp8cqrmw15yins65cn0zwbcpj1vmymr4wnbm151sfmf2kfhl4v";
  };
})
