{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "8.6";
    version = "${release}.15";

    # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      sha256 = "sha256-hh4Vl1Py4vvW7BSEEDcVsL5WvjNXUiuFjTy7X4k//vE=";
    };
  }
)
