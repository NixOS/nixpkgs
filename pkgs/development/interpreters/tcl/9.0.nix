{ callPackage, fetchzip, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "9.0";
    version = "${release}.0";

    # Note: when updating, the hash in pkgs/development/libraries/tk/9.0.nix must also be updated!

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      sha256 = "sha256-QaPSY6kfxyc3x+2ptzEmN2puZ0gSFSeeNjPuxsVKXYE=";
    };
  }
)
