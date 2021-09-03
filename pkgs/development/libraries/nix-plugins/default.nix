{ lib, stdenv, fetchFromGitHub, nix, cmake, pkg-config, boost }:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "08kxdci0sijj1hfkn3dbr7nbpb9xck0xr3xa3a0j116n4kvwb6qv";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ nix boost ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = "https://github.com/shlevy/nix-plugins";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
