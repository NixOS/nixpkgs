{ lib, stdenv, fetchFromGitHub, cmake, qt5, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "molequeue";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = pname;
    rev = version;
    sha256 = "+NoY8YVseFyBbxc3ttFWiQuHQyy1GN8zvV1jGFjmvLg=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [ qt5.qttools ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/molequeue/MoleQueueConfig.cmake \
      --replace "''${MoleQueue_INSTALL_PREFIX}/$out" "''${MoleQueue_INSTALL_PREFIX}"
  '';

  meta = with lib; {
    description = "Desktop integration of high performance computing resources";
    maintainers = with maintainers; [ sheepforce ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
