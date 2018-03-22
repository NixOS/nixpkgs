{ stdenv, fetchFromGitHub, nix, cmake, pkgconfig }:
let version = "3.0.1"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "1pmk2m0kc6a3jqygm5cy1fl5gbcy0ghc2xs4ww0gh20walrys82r";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ nix ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
