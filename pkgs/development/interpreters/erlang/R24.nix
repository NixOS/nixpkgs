{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.5";
  sha256 = "4ZyYcBhep67aPr8SY7JK/3YXD5Th8UcyjTP7UIZ5c5Q=";
}
