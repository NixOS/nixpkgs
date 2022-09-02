{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.14.0";
  sha256 = "sha256-NJQ2unK7AeLGfaW/hVXm7yroweEfudKVUa216RUmLJs=";
  minimumOTPVersion = "22";
}
