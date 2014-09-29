{ stdenv, fetchurl, pkgconfig, nix }: let
  version = "1.0.0";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "0w89ma69iil1ki68zvs1l0ii0d87in64791l3a4yzyv9d3ncl3w6";
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
