{ callPackage, fetchurl, fetchpatch }:

callPackage ./generic.nix ( rec {
  version = "0.9.72";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "sha256-Cugl+ODX9BIB/USg3xz0VMHLC8UP6dWcJlUiYCZML/g=";
  };

  patches = [
    ((import ./CVE-2023-27371.nix) fetchpatch)
  ];
})
