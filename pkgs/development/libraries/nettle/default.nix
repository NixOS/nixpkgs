{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.8.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-Nk8+K3fNfc3oP9fEUhnINOVLDHXkKLb4lKI9Et1By/4=";
  };
}
