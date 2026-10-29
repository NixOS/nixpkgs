{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "0.11.3";

    src = fetchurl {
      url = "https://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
      hash = "sha256-fmSBXUqKAJ0CgOzSNevZF9o6vc/Y99CBIhjAhflICDY=";
    };
  }
)
