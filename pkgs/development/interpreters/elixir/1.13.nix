{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.3";
  sha256 = "sha256-xOIGMpjemPi1xLiYmFpQR4FD6PzeFBxSJP4QpNnEUSE=";
  minimumOTPVersion = "22";
}
