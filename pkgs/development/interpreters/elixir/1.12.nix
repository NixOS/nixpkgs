{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.12.0";
  sha256 = "sha256-Jnxi0vFYMnwEgTqkPncZbj+cR57hjvH77RCseJdUoFs=";
  minimumOTPVersion = "22";
}
