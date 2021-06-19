{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "22.3.4.20";
  sha256 = "sha256-EUErOCW16eUb/p5dLpFV7sQ3mXlCF/OgOvGAAyYEvLo=";
}
