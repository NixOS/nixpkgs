{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wrapQtAppsHook,
  wayland-scanner,
  dtk6declarative,
  dtk6widget,
  dde-qt-dbus-factory,
  qt6Packages,
  qt6integration,
  qt6platform-plugins,
  dde-tray-loader,
  wayland,
  wayland-protocols,
  yaml-cpp,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-shell";
  version = "0.0.43";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-shell";
    rev = finalAttrs.version;
    hash = "sha256-wSk1gEJbTxKUPZ6DiTeVw2qyX+CwANA37ZP0tXnz0J0=";
  };

  patches = [
    ./fix-path-for-nixos.diff
    (fetchpatch {
      name = "fix-libdock-plugin_so-contains-a-forbidden-reference.diff";
      url = "https://github.com/linuxdeepin/dde-shell/commit/bf9a0472bc44748a3c389d796d144dad6b13617b.patch";
      hash = "sha256-cP5zMsfPyi4FIR1OIbVSnn+Z+KqRuIK7a214VjVb/7w=";
    })
  ];

  postPatch = ''
    for file in $(grep -rl "/usr/lib/dde-dock"); do
      substituteInPlace $file --replace-fail "/usr/lib/dde-dock" "/run/current-system/sw/lib/dde-dock"
    done

    for file in $(grep -rl "/usr/lib/deepin-daemon"); do
      substituteInPlace $file --replace-fail "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"
    done
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
    wayland-scanner
  ];

  buildInputs = [
    dde-tray-loader
    dtk6declarative
    dtk6widget
    dde-qt-dbus-factory
    qt6Packages.qtbase
    qt6Packages.qtwayland
    qt6Packages.qtsvg
    qt6platform-plugins
    qt6integration
    wayland
    wayland-protocols
    yaml-cpp
    xorg.libXcursor
    xorg.libXres
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  cmakeFlags = [ "-DQML_INSTALL_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtQmlPrefix}" ];

  qtWrapperArgs = [
    "--prefix TRAY_LOADER_EXECUTE_PATH : ${dde-tray-loader}/libexec/trayplugin-loader"
    "--suffix DDE_SHELL_PLUGIN_PATH : /run/current-system/sw/lib/dde-shell"
    "--suffix DDE_SHELL_PACKAGE_PATH : /run/current-system/sw/share/dde-shell"
  ];

  meta = {
    description = "A plugin system that integrates plugins developed on DDE";
    homepage = "https://github.com/linuxdeepin/dde-shell";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
