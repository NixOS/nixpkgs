{ stdenv, fetchFromGitHub, nix, cmake, pkgconfig, boost }:
let version = "5.0.0"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "0231j92504vx0f4wax9hwjdni1j4z0g8bx9wbakg6rbghl4svmdv";
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
