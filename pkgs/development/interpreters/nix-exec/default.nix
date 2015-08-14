{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.1.1";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "1igpxhvj29cgg7mid1ilaq3d1q9sk6nlw8q33ah8y78iy2ah1iv2";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    platforms = nix.meta.platforms;
  };
}
