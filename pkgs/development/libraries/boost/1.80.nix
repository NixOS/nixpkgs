{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.80.0";

    src = fetchurl {
      urls = [
        "mirror://sourceforge/boost/boost_${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.bz2"
        "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${
          builtins.replaceStrings [ "." ] [ "_" ] version
        }.tar.bz2"
      ];
      # SHA256 from http://www.boost.org/users/history/version_1_80_0.html
      hash = "sha256-HhlWXYLkO8WSCaFo9ayJnTukcdVcdhDGd9TM8snFAMA=";
    };
  }
)
