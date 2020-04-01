{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz
mkDerivation {
  version = "1.10.2";
  sha256 = "04yi1hljq7ii9flh6pmb5411z7q1bdq9f9sq8323k9hm1f5jwkx6";
  minimumOTPVersion = "21";
}
