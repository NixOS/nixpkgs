{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.11.0";
  sha256 = "0mxckjdy2gbmymvbi1bf146nhmz4icvq6917g8nbyi1gaz5l8rn2";
  minimumOTPVersion = "21";
}
