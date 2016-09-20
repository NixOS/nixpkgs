{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.15";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "161lbs0ijkkc94xx6yz87q36a055hl6d5hdwyz5s1wpm0lwh2apb";
  };
})
