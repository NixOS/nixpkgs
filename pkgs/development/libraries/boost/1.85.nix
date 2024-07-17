{
  callPackage,
  fetchurl,
  fetchpatch,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "1.85.0";

    src = fetchurl {
      urls = [
        "mirror://sourceforge/boost/boost_${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.bz2"
        "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${
          builtins.replaceStrings [ "." ] [ "_" ] version
        }.tar.bz2"
      ];
      # SHA256 from http://www.boost.org/users/history/version_1_85_0.html
      sha256 = "7009fe1faa1697476bdc7027703a2badb84e849b7b0baad5086b087b971f8617";
    };
  }
)
