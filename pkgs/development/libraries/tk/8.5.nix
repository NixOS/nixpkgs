{ callPackage, fetchurl, tcl, ... } @ args:

callPackage ./generic.nix (args // rec {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "0an3wqkjzlyyq6l9l3nawz76axsrsppbyylx0zk9lkv7llrala03";
  };

})
