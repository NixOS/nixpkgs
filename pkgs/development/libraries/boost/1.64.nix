{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.64.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_64_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_64_0.html
    sha256 = "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332";
  };

})
