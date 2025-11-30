import ./generic.nix rec {
  version = "0.27";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "sha256-bYurtZ57Zy6Mt4cOh08/e4E7bgDmrz+LBPdXmWVkPVw=";
  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];
}
