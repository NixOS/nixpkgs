{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4";
  sha256 = "EKewwcK1Gr84mmFVxVmOLaPiFtsG3r/1ubGOUwM/EYY=";
}
