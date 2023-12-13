{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, extra-cmake-modules
, pkg-config
, dtkcommon
, qtbase
, qtx11extras
, mtdev
, cairo
, xorg
, wayland
, dwayland
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.6.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-1/biT8wR44+sdOMhBW/8KMUSBDK/UxuEqsyjTZyjBT4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    dtkcommon
    mtdev
    cairo
    qtbase
    qtx11extras
    xorg.libSM
    wayland
    dwayland
    qtwayland
  ];

  patches = [
    (fetchpatch {
      name = "use-ECM-to-help-dwayland-find-wayland.patch";
      url = "https://github.com/linuxdeepin/qt5platform-plugins/commit/d7f6230716a0ff5ce34fc7d292ec0af5bbac30e4.patch";
      hash = "sha256-RY2+QBR3OjUGBX4Y9oVvIRY90IH9rTOCg8dCddkB2WE=";
    })
  ];

  cmakeFlags = [
    "-DINSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
    "-DQT_XCB_PRIVATE_HEADERS=${qtbase.src}/src/plugins/platforms/xcb"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt platform plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5platform-plugins";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
