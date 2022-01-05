{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.1";
  sha256 = "0z0b1w2vvw4vsnb99779c2jgn9bgslg7b1pmd9vlbv02nza9qj5p";
  minimumOTPVersion = "22";
}
