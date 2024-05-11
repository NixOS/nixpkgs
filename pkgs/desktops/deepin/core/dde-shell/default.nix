{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, wrapQtAppsHook
, wayland-scanner
, dtk6declarative
, dtk6widget
, qt6Packages
, libsForQt5
, wayland
, wayland-protocols
, yaml-cpp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-shell";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-shell";
    rev = "e666b487d978d34c8f7f7488d42482397755615c";
    hash = "sha256-DvcxCLKTddUtPELMN7oBcQPSbHoNWEmXYLeCo3O8rOg=";
  };

  patches = [
    ./disable-plugins-use-qt5.diff
    ./fix-translations-cant-install.diff
    ./fix-path-for-nixos.diff
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
    wayland-scanner
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtwayland
    dtk6declarative
    dtk6widget
    wayland
    wayland-protocols
    yaml-cpp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_DIR" "${placeholder "out"}/lib/systemd/user")
  ];

  meta = {
    description = "A plugin system that integrates plugins developed on DDE";
    homepage = "https://github.com/linuxdeepin/dde-shell";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
