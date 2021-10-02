{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.1";
  sha256 = "sha256-y5QtLCrYeMT4WdHkFngKv02CZ35eYZF3sjfI5OZNAH0=";
}
