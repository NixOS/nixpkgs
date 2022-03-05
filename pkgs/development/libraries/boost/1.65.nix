{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.65.1";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_65_1.html
    sha256 = "9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81";
  };

})
