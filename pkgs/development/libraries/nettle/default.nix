{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.7.3";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    sha256 = "1w5wwc3q0r97d2ifhx77cw7y8s20bm8x52is9j93p2h47yq5w7v6";
  };
}
