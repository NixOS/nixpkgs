{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.27";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.xz";
    sha256 = "0zxiavxpy2k5f8ainwfbp11mvah23nlx2l8d04sc3xcf2mna3zcd";
  };
})
