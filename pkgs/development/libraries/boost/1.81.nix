{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.81.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
      "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_81_0.html
    sha256 = "71feeed900fbccca04a3b4f2f84a7c217186f28a940ed8b7ed4725986baf99fa";
  };
})
