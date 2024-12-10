{
  fetchFromGitHub,
  lib,
  stdenv,
  coin3d,
  qtbase,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "soqt";
  version = "2020-12-05-unstable";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "soqt";
    # rev = "SoQt-${version}";
    rev = "fb8f655632bb9c9c60e0ff9fa69a5ba22d3ff99d";
    hash = "sha256-YoBq8P3Tag2Sepqxf/qIcJDBhH/gladBmDUj78aacZs=";
    fetchSubmodules = true;
  };

  buildInputs = [
    coin3d
    qtbase
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/coin3d/soqt";
    license = licenses.bsd3;
    description = "Glue between Coin high-level 3D visualization library and Qt";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
