{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "0h2vap31yvi1a438d36lg1r1nllfx3y19r4rfxv7slrm6kafnwdw";
  };
})
