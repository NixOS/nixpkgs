{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.69_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_69_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_69_0.html
    sha256 = "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406";
  };
})
