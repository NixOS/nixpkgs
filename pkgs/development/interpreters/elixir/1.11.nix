{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.11.3";
  sha256 = "sha256-DqmKpMLxrXn23fsX/hrjDsYCmhD5jbVtvOX8EwKBakc=";
  minimumOTPVersion = "21";
}
