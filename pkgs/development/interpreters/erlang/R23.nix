{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.5";
  sha256 = "2u/w8IPKHEZ+rZ3T7Wn9+Ggxe6JY8cHz8q/N0RjbrNU=";
}
