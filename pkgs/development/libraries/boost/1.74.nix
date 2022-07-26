{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.74.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
      "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_74_0.html
    sha256 = "83bfc1507731a0906e387fc28b7ef5417d591429e51e788417fe9ff025e116b1";
  };
})

