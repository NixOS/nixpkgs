{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.78.0";

    src = fetchurl {
      urls = [
        "mirror://sourceforge/boost/boost_${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.bz2"
        "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${
          builtins.replaceStrings [ "." ] [ "_" ] version
        }.tar.bz2"
      ];
      # SHA256 from http://www.boost.org/users/history/version_1_78_0.html
      hash = "sha256-hoHxddS9smxSIiZleT7vCEkNd1hSkzD5jTsp3Qc1vMw=";
    };
  }
)
