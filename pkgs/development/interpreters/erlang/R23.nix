{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.2";
  sha256 = "eU3BmBJqrcg3FmkuAIfB3UoSNfQQfvGNyC2jBffwm/w=";
}
