{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.0";
  sha256 = "sha256-HE3T+pwayH9pxBbsiF7lnaM1OckC1OZ/ndAKvWbqeeY=";
  minimumOTPVersion = "22";
}
