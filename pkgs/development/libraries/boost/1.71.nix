{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.71.0";

  src = fetchurl {
    #url = "mirror://sourceforge/boost/boost_1_71_0.tar.bz2";
    urls = [ 
      "mirror://sourceforge/boost/boost_1_71_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_71_0.html
    sha256 = "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee";
  };
})
