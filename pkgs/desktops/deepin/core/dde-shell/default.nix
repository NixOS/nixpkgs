{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wayland-scanner,
  dtk6declarative,
  dtk6widget,
  dde-qt-dbus-factory,
  qt6Packages,
  qt6integration,
  qt6platform-plugins,
  dde-tray-loader,
  dde-application-manager,
  wayland,
  wayland-protocols,
  treeland-protocols,
  yaml-cpp,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-shell";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-shell";
    rev = finalAttrs.version;
    hash = "sha256-0nyTvSIJglx8raehPi6pYfQcxIjsCAaD1hVbuGvtfY8=";
  };

  patches = [
    ./fix-path-for-nixos.diff
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://github.com/linuxdeepin/dde-shell/commit/936d62a2c20398b9ca6ae28f9101dd288c8b1678.patch";
      hash = "sha256-u5TcPy2kZsOLGUgjTGZ5JX3mWnr/rOQ3SWBRyjWEiw4=";
    })
    (fetchpatch {
      name = "adapt-import-change-of-QtQml-Models-in-Qt-6_9.patch";
      url = "https://github.com/linuxdeepin/dde-shell/commit/ad92c160508a5eb53fd5af558ef1b1ba881b97ac.patch";
      hash = "sha256-3GdkbFEt51EP04RQN54EDsGyXkeZoWhbnQAHkwjUeGY=";
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
    dde-application-manager
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
    treeland-protocols
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
