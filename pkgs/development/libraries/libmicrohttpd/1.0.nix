{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "1.0.10";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-BL/o73XbfWKaM952dZl2XOytxWJ0o5gi1dCBAw1XdoU=";
  };
}
