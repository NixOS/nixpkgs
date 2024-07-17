{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "8.6";
    version = "${release}.13";

    # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      sha256 = "sha256-Q6H650EvYf8R3iz9BdKM/Dpzdi81SkF8YjcKVOLK8GY=";
    };
  }
)
