{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.11.2";
  sha256 = "0b4nfgxhmi4gwba9h9k103zrkpbxxvk0gmdl0ggrd5xlg6v288ky";
  minimumOTPVersion = "21";
}
