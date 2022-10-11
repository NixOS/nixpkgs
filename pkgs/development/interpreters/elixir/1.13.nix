{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.14.1";
  sha256 = "sha256-/QQckiRvwmD3gdIo19TXM0bIgdxNx8eQwpd1RnEo35A=";
  minimumOTPVersion = "22";
}
