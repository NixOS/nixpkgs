{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.60.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_60_0.tar.bz2";
    sha256 = "0fzx6dwqbrkd4bcd8pjv0fpapwmrxxwr8yx9g67lihlsk3zzysk8";
  };

})
