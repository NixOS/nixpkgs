{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.1.3";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "0zhydidxj7dvgvszrlzwb0wj4s7xb42kdmn0fv5c7jz3nvnhdykp";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    platforms = nix.meta.platforms;
  };
}
