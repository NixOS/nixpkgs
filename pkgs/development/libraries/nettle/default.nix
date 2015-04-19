{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "1ly9kz5fgc8ilykz07crqwgjsfn4p2s6565gj1aq0w4fr179v1gn";
  };
})
