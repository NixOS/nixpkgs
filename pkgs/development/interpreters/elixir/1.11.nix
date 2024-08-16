{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.11.4";
  sha256 = "sha256-qCX6hRWUbW+E5xaUhcYxRAnhnvncASUJck8lESlcDvk=";
  minimumOTPVersion = "21";
}
