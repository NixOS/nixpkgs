{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "8.5";
    version = "${release}.19";

    # Note: when updating, the hash in pkgs/development/libraries/tk/8.5.nix must also be updated!

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      sha256 = "066vlr9k5f44w9gl9382hlxnryq00d5p6c7w5vq1fgc7v9b49w6k";
    };
  }
)
