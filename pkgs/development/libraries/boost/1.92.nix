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
        sha256 = "5c1d40cb8e19adbf740a4ec2da35b3e58f3f5804b1dce44deb53df72193cbc6c";
      };
  }
)
