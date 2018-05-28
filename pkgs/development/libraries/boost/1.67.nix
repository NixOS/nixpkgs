{ stdenv, callPackage, fetchurl, hostPlatform, buildPlatform, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.67_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_67_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_66_0.html
    sha256 = "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba";
  };

  toolset = if stdenv.cc.isClang then "clang" else null;
})
