{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.7.2";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "0qpi1qp3bcvqdsaxy2pzg530db95x8qjahkynxgwvr6dy5760ald";
  };
}
