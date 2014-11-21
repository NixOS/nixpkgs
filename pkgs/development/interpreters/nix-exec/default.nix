{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "3.0.1";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "1ncyhmwch9l2iz58ycfy53bb3l850d24aryraf6vvfkw8yg9d7kq";
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
