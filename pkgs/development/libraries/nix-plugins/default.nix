{ lib, stdenv, fetchFromGitHub, nix, cmake, pkg-config, boost }:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    hash = "sha256-7Lo+YxpiRz0+ZLFDvYMJWWK2j0CyPDRoP1wAc+OaPJY=";
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
