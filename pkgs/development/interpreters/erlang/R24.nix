{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.1.3";
  sha256 = "sha256-l0+eZh4F/erY0ZKikUilRPiwkIhEL1Fb5BauR7gh+Ew=";
}
