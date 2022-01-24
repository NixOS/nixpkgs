import ./generic.nix rec {
  version = "0.24";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "1bgbk6n93qqn7w8v21kxf4x6dc3z0ypqrzvgfd46nhagak60ac84";
  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];
}
