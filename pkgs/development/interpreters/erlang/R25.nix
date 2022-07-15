{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "25.0.2";
  sha256 = "01jgmrskm04vdx560wry4xjy7xj57b82fhwyhn42hpv5k3dz4lp7";
}
