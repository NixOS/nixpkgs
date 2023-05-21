{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.7";
  version = "${release}a5";

  # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "sha256-igGFio6KuBL6p6qa+NzBwBiRvp1pVUsBeKQja6HAofA=";
  };
})
