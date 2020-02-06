{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.10.0";
  sha256 = "1fz22c2jqqm2jvzxar11bh1djg3kqdn5rbxdddlz0cv6mfz7hvgv";
  minimumOTPVersion = "21";
}
