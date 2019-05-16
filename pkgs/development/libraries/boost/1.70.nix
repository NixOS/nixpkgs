{ stdenv, callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.70.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_70_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_70_0.html
    sha256 = "430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778";
  };
})
