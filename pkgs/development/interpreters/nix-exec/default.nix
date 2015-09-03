{ stdenv, fetchurl, pkgconfig, nix, git }: let
  version = "4.1.2";
in stdenv.mkDerivation {
  name = "nix-exec-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/nix-exec/releases/download/v${version}/nix-exec-${version}.tar.xz";

    sha256 = "03dphdkf33zi2wm92wghfvadghljh6q1a9zdj9rcbx2jh7fp3k8y";
  };

  buildInputs = [ pkgconfig nix git ];

  meta = {
    description = "Run programs defined in nix expressions";

    homepage = https://github.com/shlevy/nix-exec;

    license = stdenv.lib.licenses.mit;

    platforms = nix.meta.platforms;
  };
}
