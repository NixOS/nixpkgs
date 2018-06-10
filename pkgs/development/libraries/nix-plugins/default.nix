{ stdenv, fetchFromGitHub, nix, cmake, pkgconfig, boost }:
let version = "4.0.5"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "170f365rnik62fp9wllbqlspr8lf1yb96pmn2z708i2wjlkdnrny";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ nix boost ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
