{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.9";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-Duet9acgFhC7f+Csu3ybO+g75EkE3TXrvNllzYlr/qo=";
  };
}
