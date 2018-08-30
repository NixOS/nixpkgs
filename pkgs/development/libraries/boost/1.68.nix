{ stdenv, callPackage, fetchurl, fetchpatch, hostPlatform, buildPlatform, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.68_0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_68_0.tar.bz2";
    # SHA256 from http://www.boost.org/users/history/version_1_68_0.html
    sha256 = "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7";
  };
})
