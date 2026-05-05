{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.91.0";

    src =
      let
        underVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
      in
      fetchurl {
        urls = [
          "https://archives.boost.io/release/${version}/source/boost_${underVersion}.tar.bz2"
          # "mirror://sourceforge/boost/boost_${underVersion}.tar.bz2" 1.91.0.beta1 is available, but not 1.91.0
        ];
        # SHA256 from https://www.boost.org/releases/1.91.0/
        sha256 = "de5e6b0e4913395c6bdfa90537febd9028ea4c0735d2cdb0cd9b45d5f51264f5";
      };
  }
)
