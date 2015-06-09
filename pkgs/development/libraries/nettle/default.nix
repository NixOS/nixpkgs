{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.1.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "0k1x57zviysvi91lkk66cg8v819vywm5g5yqs22wppfqcifx5m2z";
  };
})
