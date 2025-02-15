{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.82.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
      "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_82_0.html
    sha256 = "a6e1ab9b0860e6a2881dd7b21fe9f737a095e5f33a3a874afc6a345228597ee6";
  };

  patches = [
    (fetchpatch {
      name = "avoid-phoenix-odr.patch";
      url = "https://github.com/boostorg/phoenix/commit/665047aac26ad4d96b266d87504b3a88ad21b37e.diff";
      hash = "sha256-JUK5iMnInNJw/5ybHTO2gsOOYgcGKAkhA4LyL3RDRn0=";
      stripLen = 1;
    })
  ];
})
