{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.0";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.lz";
    sha256 = "0mhym25ns3fhjd82p6g0aafhzbfkanryqbxvjy9mi25n2xpr1b95";
  };

  patches = [ ./install-fix.patch ];
})
