{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.3";
  sha256 = "wmR0XTMrJ3608HD341lNlYChwxs/8jb12Okw3RNHGCA=";
}
