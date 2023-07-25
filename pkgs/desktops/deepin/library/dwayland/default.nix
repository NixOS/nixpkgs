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
  version = "5.24.3-deepin.1.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-/aWS4uvhxi9azxJWjRE+Bw+veURFO+mC8l9yypseclU=";
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
