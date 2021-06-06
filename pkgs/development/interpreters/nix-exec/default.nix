{ lib, stdenv, fetchurl, pkg-config, nix, git }: let
  version = "4.1.6";
in stdenv.mkDerivation {
  pname = "nix-exec";
  inherit version;

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";
    sha256 = "0slpsnzzzdkf5d9za7j4kr15jr4mn1k9klfsxibzy47b2bx1vkar";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ nix git ];

  NIX_CFLAGS_COMPILE = "-std=c++1y";

  meta = {
    description = "Run programs defined in nix expressions";
    homepage = "https://github.com/shlevy/nix-exec";
    license = lib.licenses.mit;
    platforms = nix.meta.platforms;
    broken = true;
  };
}
