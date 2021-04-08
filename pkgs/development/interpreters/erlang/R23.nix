{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.1";
  sha256 = "1nx9yv3l8hf37js7pqs536ywy786mxhkqba1jsmy1b3yc6xki1mq";
}
