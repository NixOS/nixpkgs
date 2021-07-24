{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.4";
  sha256 = "OeXXNaVJh5el+V+5ukcNOAgDmkJuGy1lYLpUTd1yxHM=";
}
