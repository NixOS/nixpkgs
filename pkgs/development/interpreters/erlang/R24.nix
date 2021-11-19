{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.6";
  sha256 = "sha256-Jh9w3+ft1RZjmb4PriCmHPj0tgkx8LBFjsg1s4BGojs=";
}
