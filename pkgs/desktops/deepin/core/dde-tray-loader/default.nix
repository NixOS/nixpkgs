{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  dtkwidget,
  dde-qt-dbus-factory,
  wayland,
  wayland-scanner,
  xorg,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-tray-loader";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-tray-loader";
    rev = "${finalAttrs.version}";
    hash = "sha256-ssgDLBzDFDs8FgtMHwa2k+3E3wOc8i0sVvYiYkb7lyE=";
  };

  postPatch = ''
    substituteInPlace plugins/dde-dock/CMakeLists.txt \
      --replace 'add_subdirectory("eye-comfort-mode")' " "
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
    wayland-scanner
  ];

  buildInputs = [
    dtkwidget
    dde-qt-dbus-factory
    libsForQt5.qtbase
    libsForQt5.qtwayland
    libsForQt5.networkmanager-qt
    libsForQt5.libdbusmenu
    wayland
    xorg.libXcursor
    xorg.libXtst
  ];

  meta = {
    description = "Tray plugins that integrated into task bar";
    homepage = "https://github.com/linuxdeepin/dde-tray-loader";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
