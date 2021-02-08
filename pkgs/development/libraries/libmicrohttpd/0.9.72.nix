{ callPackage, fetchurl }:

callPackage ./generic.nix ( rec {
  version = "0.9.72";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-Cugl+ODX9BIB/USg3xz0VMHLC8UP6dWcJlUiYCZML/g=";
  };
})
