{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "0.7.1";

    src = fetchurl {
      url = "https://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
      hash = "sha256-k/Di37WQIbGeadwN7oVeuJ8ZOX2x3qDQ1vkynP+TMGY=";
    };
  }
)
