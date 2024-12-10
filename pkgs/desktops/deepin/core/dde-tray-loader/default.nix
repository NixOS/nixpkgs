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
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-tray-loader";
    rev = finalAttrs.version;
    hash = "sha256-LzRjOl3kHArpxwerh7XOisYIJ+t+r/zWUbvYh6k6zKw=";
  };

  patches = [
    (fetchpatch {
      name = "remove-useless-function.patch";
      url = "https://github.com/linuxdeepin/dde-tray-loader/commit/cf85f68db52472a0291bbbc3c298d7a2b701e4bc.patch";
      hash = "sha256-ks7Rg5kLQvo03XKbfQaqu/heP2yoVEbNO6UhDv99JBY=";
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
