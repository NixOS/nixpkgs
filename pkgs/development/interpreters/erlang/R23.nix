{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.3.4.10";
  sha256 = "0sfz7n748hvhmcygnvb6h31ag35p59aaa9h8gdpqsh6p4hnjh1mf";
}
