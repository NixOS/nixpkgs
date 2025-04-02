{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.81.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
      "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_81_0.html
    sha256 = "71feeed900fbccca04a3b4f2f84a7c217186f28a940ed8b7ed4725986baf99fa";
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
