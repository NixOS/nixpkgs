{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.77.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_1_77_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.77.0/source/boost_1_77_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_77_0.html
    sha256 = "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854";
  };
})

