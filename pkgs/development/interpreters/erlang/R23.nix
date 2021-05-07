{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.3";
  sha256 = "eT4ufUkupu+RtTB27sxMXpImSXNlQ0eYyzr8NTYdeuk=";
}
