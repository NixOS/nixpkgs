{ callPackage, fetchurl, libunistring, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.8";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "1zyl2z63s68hx1dpxqx0lykmlf3rwrzlrf44sq3h7dvjmr1z55qf";
  };

  buildInputs = [ libunistring ];
})
