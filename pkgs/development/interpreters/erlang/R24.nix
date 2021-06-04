{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.0.2";
  sha256 = "gAiQc+AVj5xjwAnn9mF4xprjZOft1JvfEFVJMG5isxg=";
}
