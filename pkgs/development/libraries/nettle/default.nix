{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.10";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-tMUYrbF05ITLSs6lQRjwI4DHEzdx5+m+uYoHhxlO5Hw=";
  };
}
