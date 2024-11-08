{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.12.3";
  sha256 = "sha256-Jo9ZC5cSBVpjVnGZ8tEIUKOhW9uvJM/h84+VcnrT0R0=";
  minimumOTPVersion = "22";
}
