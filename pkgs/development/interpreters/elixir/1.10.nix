{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.10.3";
  sha256 = "18bqqqzvhr1zj491wc3d36a310mg1wcs12npp70zfmgqrc60q65a";
  minimumOTPVersion = "21";
}
