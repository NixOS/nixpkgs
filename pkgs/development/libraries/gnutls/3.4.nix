{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.3";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.lz";
    sha256 = "1q4adb1xi9pl00iy3cqs4r1qmwllv1g1r44p6xsg6n65dpyf53q2";
  };
})
