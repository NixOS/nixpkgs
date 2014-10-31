{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "2.0.1";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "1iyz19c15yw0p5lgfbfh8arja2cy3apx5697cm671j4qzjkws32p";
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
