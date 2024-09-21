{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  pkg-config,
  dtkwidget,
  dde-qt-dbus-factory,
  qt5integration,
  qt5platform-plugins,
  wayland,
  wayland-scanner,
  xorg,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-tray-loader";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-tray-loader";
    rev = finalAttrs.version;
    hash = "sha256-kz8+essf6O3ckeY5/5a/Z6539qNcfOnGbGTqSo5swhc=";
  };

  patches = [
    (fetchpatch {
      name = "set-version-for-dde-dock_pc.patch";
      url = "https://github.com/linuxdeepin/dde-tray-loader/commit/0f9b90a9aa8096a92c21c8f01d29b4785aaf04e5.patch";
      hash = "sha256-A6k8XjyIDbA+XuUxYWd5yxFJ8yOWMOtUH5Vg10o//YM=";
    })
  ];

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
    qt5integration
    qt5platform-plugins
    libsForQt5.qtbase
    libsForQt5.qtsvg
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
