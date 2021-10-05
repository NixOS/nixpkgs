{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.2";
  sha256 = "sha256-P0XU+gqDyhW0QQf1UzO+CV9Yc6YP70MRf3MLgdKzeU4=";
}
