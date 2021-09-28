{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.12.3";
  sha256 = "07fisdx755cgyghwy95gvdds38sh138z56biariml18jjw5mk3r6";
  minimumOTPVersion = "22";
}
