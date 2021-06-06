{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "22.3.4.19";
  sha256 = "sha256-U3ks7pDIqS8HVJ+yBobhEbKvnd9svEcQd9BsJQwajDs=";
}
