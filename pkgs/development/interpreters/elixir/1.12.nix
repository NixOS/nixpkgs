{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.12.2";
  sha256 = "sha256-PQkvBaQQljATt+LA3hWJOFyQessqqR1t6o1J2LHllec=";
  minimumOTPVersion = "22";
}
