{ stdenv, fetchFromGitHub, nix, cmake, pkgconfig, boost }:
let version = "4.0.4"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "02lz62n55pvqin4x44qlxb5knrapyckmj9k8ggk4qxgb36368ifn";
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
