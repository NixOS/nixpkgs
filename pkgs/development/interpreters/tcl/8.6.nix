{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "8.6";
    version = "${release}.16";

    # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-kcuPphdxxjwmLvtVMFm3x61nV6+lhXr2Jl5LC9wqFKU=";
    };
  }
)
