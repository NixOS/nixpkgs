{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.17";
  sha256 = "sha256-GJicQqQbtD/eG/1t9C/l3hVsRV8fJOgaSCU0/kSHZLY=";
}
