{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.59.0";

  boostBuildPatches = [
    # Fixes a segfault on aarch64-darwin from an implicitly defined varargs function.
    # https://github.com/boostorg/build/pull/238
    (fetchpatch {
      url = "https://github.com/boostorg/build/commit/48e9017139dd94446633480661e5447c7e0d8b1b.diff";
      excludes = [
        # Doesn't apply, isn't critical.
        "src/engine/filesys.h"
      ];
      sha256 = "sha256-/HLOJKBcGqcK9yBYKSRCSMmTNhCH3sSpK1s3OzkIqx8";
    })
  ];

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2";
    sha256 = "1jj1aai5rdmd72g90a3pd8sw9vi32zad46xv5av8fhnr48ir6ykj";
  };
})
