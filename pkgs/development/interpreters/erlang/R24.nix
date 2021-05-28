{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.1";
  sha256 = "z01gaKNkKsIPKdPKhX6IUUY9uBSuyA33E4aVM0MdXsg=";
}
