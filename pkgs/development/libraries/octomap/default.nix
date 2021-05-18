{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "octomap";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = pname;
    rev = "v${version}";
    sha256 = "03v341dffa0pfzmf2431xb5nq50zq9zlhgl6k2aa3fsza5xmbb70";
  };
  sourceRoot = "source/octomap";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
