{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.9";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "0kjzj7mkzfnb7ksxanbibibfpciyvsh5ffdlhs0bmfc75kgd435d";
  };
})
