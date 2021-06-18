{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.76.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_1_76_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.76.0/source/boost_1_76_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_76_0.html
    sha256 = "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41";
  };
})
