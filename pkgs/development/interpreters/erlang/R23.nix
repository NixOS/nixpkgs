{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.1";
  sha256 = "vBGPCAq7410ykiWsxDo6PpgnInPMY35+RPx4gl/BW7k=";
}
