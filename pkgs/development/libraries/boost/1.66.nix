{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.66.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_66_0.html
    sha256 = "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9";
  };
})
