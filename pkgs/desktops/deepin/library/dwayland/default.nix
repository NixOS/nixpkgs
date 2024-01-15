{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, qtwayland
, wayland
, wayland-protocols
, extra-cmake-modules
, deepin-wayland-protocols
, qttools
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

  # cmake requires that the kf5 directory must not empty
  postInstall = ''
     mkdir $out/include/KF5
  '';

  meta = with lib; {
    description = "Qt-style API to interact with the wayland-client and wayland-server";
    homepage = "https://github.com/linuxdeepin/dwayland";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
