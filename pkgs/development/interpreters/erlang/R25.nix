{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "25.0-rc3";
  sha256 = "1ir42hz81bzxn1shqq0gn824hxd6j774889vjy68psi95psfs8r2";
}
