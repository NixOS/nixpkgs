{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.5";
  sha256 = "sha256-MSPoJpbL9WeERqCSh9fiw9jhJGssqolxudyURpiypb0=";
}
