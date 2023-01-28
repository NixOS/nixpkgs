{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.4";
  sha256 = "sha256-xGKq62wzaIfgZN2j808fL3b8ykizQVPuePWzsy2HKfw=";
  minimumOTPVersion = "22";
}
