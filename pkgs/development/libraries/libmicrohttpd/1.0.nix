{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-3zJPzQg0F12rB0gxM5Atl3SmBb+imAJfaYgyiP0gqMc=";
  };
}
