import ./generic.nix rec {
  version = "0.28";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "sha256-PcMbjhsYMp5C1d+/hN1V4VxZthVpoqskb2FJfZWS9yc=";
  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];
}
