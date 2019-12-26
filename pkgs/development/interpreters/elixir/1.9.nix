{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.9.4";
  sha256 = "1l4318g35y4h0vi2w07ayc3jizw1xc3s7hdb47w6j3iw33y06g6b";
  minimumOTPVersion = "20";
}
