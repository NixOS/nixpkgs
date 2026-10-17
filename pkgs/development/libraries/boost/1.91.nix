{
  lib,
  callPackage,
  fetchurl,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.91.0";

    src =
      let
        underVersion = lib.replaceString "." "_" version;
      in
      fetchurl {
        urls = [
          "https://archives.boost.io/release/${version}/source/boost_${underVersion}.tar.bz2"
          # "mirror://sourceforge/boost/boost_${underVersion}.tar.bz2" 1.91.0.beta1 is available, but not 1.91.0
        ];
        # SHA256 from https://www.boost.org/releases/1.91.0/
        hash = "sha256-3l5rDkkTOVxr36kFN/69kCjqTAc10s2wzZtF1fUSZPU=";
      };
  }
)
