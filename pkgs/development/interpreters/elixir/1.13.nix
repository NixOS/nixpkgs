{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.0";
  sha256 = "1rkrx9kbs2nhkmzydm02r4wkb8wxwmg8iv0nqilpzj0skkxd6k8w";
  minimumOTPVersion = "22";
}
