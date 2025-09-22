import ./generic.nix rec {
  version = "0.23";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "sha256-XvxT767xUTAfTn3eOFa2aBLYFT3t4k+rF2c/gByGmPI=";
  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];
}
