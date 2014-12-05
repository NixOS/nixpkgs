{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.0.0";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "0qw25v8pzx08mirhy46dmqj93nwnxfvgw2jsn8rvxh2d7x4nc8jv";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = nix.meta.platforms;
  };
}
