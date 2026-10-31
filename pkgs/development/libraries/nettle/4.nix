{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "4.0";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-Ot28ANoBhGsjL7O8RTU46lRo2kMDPyG7NFyx6Qc/UJQ=";
  };
}
