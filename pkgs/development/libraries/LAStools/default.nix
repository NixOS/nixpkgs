{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "LAStools";
  version = "201003"; # LAStools makes release-ish commits with a message containing their version number as YYMMDD; these align with their website changelog

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "635b76b42cc4912762da31b92f875df5310e1714";
    sha256 = "0682ca3bp51lmfp46vsjnd1bqpn05g95pf4kclvjv1y8qivkxsaq";
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
