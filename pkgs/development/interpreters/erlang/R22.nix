{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "22.3.4.17";
  sha256 = "sha256-YhKU9I4qN+TVG3t//t9htUBkOu8DS75vbn/qWvS1zc0=";
}
