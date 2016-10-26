{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.2";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "15wxhk52yc62rx0pddmry66hqm6z5brrrkx4npd3wh9nybg86hpa";
  };
})
