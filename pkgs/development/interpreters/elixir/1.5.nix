{ mkDerivation }:

# to generate sha256 use nix-prefetch-git git@github.com:elixir-lang/elixir.git --rev 05418eaa4bf4fa8473900741252d93d76ed3307b

mkDerivation rec {
  version = "1.5.2";
  sha256 = "0ng7z2gz1c8lkn07fric18b3awcw886s9xb864kmnn2iah5gc65j";
  minimumOTPVersion = "18";
}
