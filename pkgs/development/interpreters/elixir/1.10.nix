{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.10.4";
  sha256 = "16j4rmm3ix088fvxhvyjqf1hnfg7wiwa87gml3b2mrwirdycbinv";
  minimumOTPVersion = "21";
}
