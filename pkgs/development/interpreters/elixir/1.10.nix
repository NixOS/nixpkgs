{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.10.1";
  sha256 = "07iccn90yp11ms58mwkwd9ixd9vma0025l9zm6l7y0jjzrj3vycy";
  minimumOTPVersion = "21";
}
