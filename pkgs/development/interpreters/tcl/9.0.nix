{ callPackage, fetchzip, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "9.0";
    version = "${release}.3";

    # Note: when updating, the hash in pkgs/development/libraries/tk/9.0.nix must also be updated!

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-qKh2QYRy+dcX3tk6DS23YfrKfiN9V8RMU1es999KBE0=";
    };
  }
)
