{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.7";
  sha256 = "sha256-R4rZVMn9AGvOy31eA1dsz2CFMKOG/cXkbLaJtT7zBrU=";
}
