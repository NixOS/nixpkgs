{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.4";
  sha256 = "sha256-QE2VRayIswVrAOv9/bq+ebv3xxIL3fFMnfm5u1Wh8j4=";
}
