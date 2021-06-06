{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.72.0";

  src = fetchurl {
    #url = "mirror://sourceforge/boost/boost_1_72_0.tar.bz2";
    urls = [
      "mirror://sourceforge/boost/boost_1_72_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_72_0.html
    sha256 = "59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722";
  };
})

