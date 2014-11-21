{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "3.0.0";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "1c5akl24jym30cfhqg9wx2mzlcx6d91fh62dvf1l13y1akqrsk06";
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
