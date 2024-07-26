{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "LAStools";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "v${version}";
    sha256 = "sha256-HL64koe0GNzJzyA0QP4I0M1y2HSxigsZTqOw67RCwNc=";
  };

  patches = [
    ./drop-64-suffix.patch # necessary to prevent '64' from being appended to the names of the executables
  ];

  hardeningDisable = [
    "format"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Software for rapid LiDAR processing";
    homepage = "http://lastools.org/";
    license = licenses.unfree;
    maintainers = with maintainers; [ stephenwithph ];
    platforms = platforms.unix;
  };
}
