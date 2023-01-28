{ lib, stdenv, fetchFromGitHub, cmake, pkg-config }:

stdenv.mkDerivation {
  pname = "sgp4";
  version = "unstable-2021-01-11";

  src = fetchFromGitHub {
    owner = "dnwrnr";
    repo = "sgp4";
    rev = "ca9d4d97af4ee62461de6f13e0c85d1dc6000040";
    sha256 = "sha256-56It/71R10U+Hnhw2tC16e5fZdyfQ8DLx6LVq65Rjvc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Simplified perturbations models library";
    homepage = "https://github.com/dnwrnr/sgp4";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.linux;
  };
}
