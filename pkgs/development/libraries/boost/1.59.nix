{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.59.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_59_0.tar.bz2";
    sha256 = "1jj1aai5rdmd72g90a3pd8sw9vi32zad46xv5av8fhnr48ir6ykj";
  };
})
