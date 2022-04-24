{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "22.3.4.24";
  sha256 = "0c9713xa8sjw7nr55hysgcnbvj7gzbrpzdl94y1nqn7vw4ni8is3";
}
