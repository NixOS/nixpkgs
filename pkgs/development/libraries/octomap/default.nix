{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "octomap";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qE5i4dGugm7tR5tgDCpbla/R7hYR/PI8BzrZQ4y6Yz8=";
  };

  sourceRoot = "source/octomap";

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE = [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

  meta = with lib; {
    description = "A probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
