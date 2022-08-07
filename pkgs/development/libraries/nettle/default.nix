{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.8";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-dXbGhIHBmPZEsIwWDRpIULqUSeMIBpRVtSEzGfI06OY=";
  };
}
