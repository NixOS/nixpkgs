{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "06clvkdfxhlbagn4afssylmn5vrak59dlmnvy8b2xc31hycs3k3m";
  };
})
