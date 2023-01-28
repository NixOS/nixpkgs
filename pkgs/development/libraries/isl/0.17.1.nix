import ./generic.nix rec {
  version = "0.17.1";
  urls = [
    "mirror://sourceforge/libisl/isl-${version}.tar.xz"
    "https://libisl.sourceforge.io/isl-${version}.tar.xz"
  ];
  sha256 = "be152e5c816b477594f4c6194b5666d8129f3a27702756ae9ff60346a8731647";
}
