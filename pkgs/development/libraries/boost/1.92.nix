{
  lib,
  callPackage,
  fetchurl,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.92.0";

    src =
      let
        underVersion = lib.replaceString "." "_" version;
      in
      fetchurl {
        urls = [
          "https://archives.boost.io/release/${version}/source/boost_${underVersion}.tar.bz2"
          "mirror://sourceforge/boost/boost_${underVersion}.tar.bz2"
        ];
        # SHA256 from https://www.boost.org/releases/1.92.0/
        hash = "sha256-XB1Ay44Zrb90Ck7C2jWz5Y8/WASx3ORN61Pfchk8vGw=";
      };
  }
)
