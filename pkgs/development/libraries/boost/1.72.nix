{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.72.0";

  src = fetchurl {
    #url = "mirror://sourceforge/boost/boost_1_71_0.tar.bz2";
    urls = [ 
      "mirror://sourceforge/boost/boost_1_72_0.tar.bz2"
      "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_71_0.html
    sha256 = "08h7cv61fd0lzb4z50xanfqn0pdgvizjrpd1kcdgj725pisb5jar";
  };
})
