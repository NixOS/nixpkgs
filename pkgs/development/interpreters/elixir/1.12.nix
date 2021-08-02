{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.12.2";
  sha256 = "1rwmwnqxhjcdx9niva9ardx90p1qi4axxh72nw9k15hhlh2jy29x";
  minimumOTPVersion = "22";
}
