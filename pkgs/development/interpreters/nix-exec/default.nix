{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.1.0";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "16hssxv6fwi5a6bz7dlvhjjr3ymiqrvq0xfd38gwhn9qhvynv2ak";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    platforms = nix.meta.platforms;
  };
}
