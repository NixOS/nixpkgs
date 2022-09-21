{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "25.1";
  sha256 = "1wrdcc576ad4fibm95c3mfni8sg1h536b4affdj05qg5cyjjwwis";
}
