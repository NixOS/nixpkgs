{ callPackage, fetchzip, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "9.0";
    version = "${release}.1";

    # Note: when updating, the hash in pkgs/development/libraries/tk/9.0.nix must also be updated!

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-NWwCQGyaUzfTgHqpib4lLeflULWKuLE4qYxP+0EizHs=";
    };
  }
)
