{ callPackage, fetchurl, libunistring, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.9";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "0l9971841jsfdcvcyhas17sk5rsby6x5vvwcmmj4x3zi9q60zcc2";
  };
})
