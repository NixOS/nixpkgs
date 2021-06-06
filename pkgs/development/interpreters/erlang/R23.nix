{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.2";
  sha256 = "QAIkiYBhYnUzyRg70SQ4BwjjYqclDA4uruqRNTgB2Sk=";
}
