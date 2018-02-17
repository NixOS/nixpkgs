{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.8";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "0sprsg7wnraa4cbwgbcliylm6p0rspfymxn8ww02pr4ca70v0g64";
  };
})
