{ stdenv, fetchFromGitHub, nix, cmake, pkgconfig, boost }:
let version = "4.0.1"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "1v7wf9l1zjlvpy23v03q5lc8d16isqb7wv1nqry1jjm0bcva72jg";
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
