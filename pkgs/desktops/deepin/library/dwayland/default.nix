{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qttools
, qtbase
, qtwayland
, wayland
, wayland-protocols
, deepin-wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "dwayland";
  version = "5.25.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-XZvL3lauVW5D3r3kybpS3SiitvwEScqgYe2h9c1DuCs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
  ];

  buildInputs = [
    qtbase
    qtwayland
    wayland
    wayland-protocols
    deepin-wayland-protocols
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt-style API to interact with the wayland-client and wayland-server";
    homepage = "https://github.com/linuxdeepin/dwayland";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
