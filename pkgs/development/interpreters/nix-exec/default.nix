{ stdenv, fetchurl, pkgconfig, nix }: let
  version = "1.1.0";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "0w1dq2svv1l8x18q5syraf80xpyyrcxbrab51cszc3v4m04b4saa";
  };

  buildInputs = [ pkgconfig nix ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = nix.meta.platforms;
  };
}
