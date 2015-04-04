{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.3.14";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-${version}.tar.lz";
    sha256 = "1117j71ng66syddw10yazrniqkd326hcigx2hfcw4s86rk0kqanv";
  };
})
