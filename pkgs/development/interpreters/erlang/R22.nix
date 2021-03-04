{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "22.3.4.16";
  sha256 = "sha256-V0RwEPfjnHtEzShNh6Q49yGC5fbt2mNR4xy6f6iWvck=";
}
