{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.1.5";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "1npy1did5ysacshclpfxihgh5bc0i9jqmvgxi1fp8prhcdhall9m";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    platforms = nix.meta.platforms;
  };
}
