{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "25.0.3";
  sha256 = "0zchcm7gv52j30fq5p658h9c593ziirq09kkah6mpsvjfdsmvmgl";
}
