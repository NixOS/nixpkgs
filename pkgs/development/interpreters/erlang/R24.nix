{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0";
  sha256 = "0p4p920ncsvls9q3czdc7wz2p7m15bi3nr4306hqddnxz1kxcm4w";
}
