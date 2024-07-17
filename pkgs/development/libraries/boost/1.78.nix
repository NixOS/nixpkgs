{
  callPackage,
  fetchurl,
  fetchpatch,
  ...
}@args:

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
      sha256 = "8681f175d4bdb26c52222665793eef08490d7758529330f98d3b29dd0735bccc";
    };
  }
)
