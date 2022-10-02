{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "24.3.4.5";
  sha256 = "sha256-MGmuge79Dh/HXF+tkvubM979K0At5v1B1RhM5Koy8oY=";
}
