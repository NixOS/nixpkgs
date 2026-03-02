{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "0.7.1";

    src = fetchurl {
      url = "http://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
      sha256 = "0rihjgzrqcprsv8a1pmiglwik7xqbs2yw3fwd6gb28chnpgy5w4k";
    };
  }
)
