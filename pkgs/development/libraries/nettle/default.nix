{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.6";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "1wg3sprl0bzy49cmbwwm91vw67hk1x5i3ksdygsciyxz587hsk6j";
  };
})
