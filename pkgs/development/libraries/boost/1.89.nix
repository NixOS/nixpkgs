{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.89.0";

    src = fetchurl {
      urls = [
        "mirror://sourceforge/boost/boost_${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.bz2"
        "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${
          builtins.replaceStrings [ "." ] [ "_" ] version
        }.tar.bz2"
      ];
      # SHA256 from http://www.boost.org/users/history/version_1_89_0.html
      sha256 = "85a33fa22621b4f314f8e85e1a5e2a9363d22e4f4992925d4bb3bc631b5a0c7a";
    };
  }
)
