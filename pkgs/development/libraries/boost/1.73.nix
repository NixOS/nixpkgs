{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.73.0";

  src = fetchurl {
    #url = "mirror://sourceforge/boost/boost_1_73_0.tar.bz2";
    urls = [
      "mirror://sourceforge/boost/boost_1_73_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_73_0.html
    sha256 = "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402";
  };
})

