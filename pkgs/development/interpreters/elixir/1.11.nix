{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.11.1";
  sha256 = "0czyv98sq9drlvdwv3gw9vnhn8qa3va4xh5vdqpg7m6b93l1r3p1";
  minimumOTPVersion = "21";
}
