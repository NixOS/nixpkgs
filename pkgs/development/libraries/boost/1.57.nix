{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.57.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_57_0.tar.bz2";
    sha256 = "0rs94vdmg34bwwj23fllva6mhrml2i7mvmlb11zyrk1k5818q34i";
  };
})
