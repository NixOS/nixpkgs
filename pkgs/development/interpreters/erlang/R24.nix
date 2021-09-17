{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.6";
  sha256 = "0z01hkzf2y6lz20s2vkn4q874lb6n6j00jkbgk4gg60rhrmq904z";
}
