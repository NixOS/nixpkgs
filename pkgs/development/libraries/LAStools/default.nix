{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "LAStools";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "v${version}";
    sha256 = "19y49j5af3z3fsiknq9kg9yjcsr73ywng8dfy837y97q4shc9g00";
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
