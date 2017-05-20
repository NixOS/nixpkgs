{ stdenv, fetchurl, pkgconfig, nix, git, gcc6 }: let
  version = "4.1.6";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";
    sha256 = "0slpsnzzzdkf5d9za7j4kr15jr4mn1k9klfsxibzy47b2bx1vkar";
  };

  buildInputs = [ pkgconfig nix git gcc6 ];

  NIX_CFLAGS_COMPILE = "-std=c++1y";

  meta = {
    description = "Run programs defined in nix expressions";
    homepage = https://github.com/shlevy/nix-exec;
    license = stdenv.lib.licenses.mit;
    platforms = nix.meta.platforms;
  };
}
