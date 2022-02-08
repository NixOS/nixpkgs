{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.13.2";
  sha256 = "sha256-qv85aDP3RPCa1YBo45ykWRRZNanL6brNKDMPu9SZdbQ=";
  minimumOTPVersion = "22";
}
