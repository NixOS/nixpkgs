{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.4";
  sha256 = "dnoSGfBUZrgcnNQNAoqmVOxK/NQlt1DC187sxg7mPq8=";
}
