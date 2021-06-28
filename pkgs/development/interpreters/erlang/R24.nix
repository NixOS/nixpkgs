{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.3";
  sha256 = "KVMISrWNBkk+w37gB4M5TQkgm4odZ+GqLvKN4stzOUI=";
}
