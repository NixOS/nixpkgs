{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "25.0";
  sha256 = "1nf72yiirdpxcs8m10xc04ryghxxc73x954x38m5a6fhv2hfhp2n";
}
