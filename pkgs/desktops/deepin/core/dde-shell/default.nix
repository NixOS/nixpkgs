{
  stdenv,
  lib,
  fetchFromGitHub,
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
  kdePackages,
  wayland,
  wayland-protocols,
  yaml-cpp,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dde-shell";
  version = "0.0.23-unstable-2024-06-11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dde-shell";
    rev = "d68cc64ad2cd6978af2f34deb3ef48f991d54fc3";
    hash = "sha256-hVrdfbtcL3EJitiDghNSuGr5MX/VVT1J3tuY6wjwYcw=";
  };

  patches = [
    ./disable-plugins-use-qt5.diff
    ./fix-path-for-nixos.diff
    ./only-use-qt6.diff # remove in next release
  ];

  postPatch = ''
    for file in $(grep -rl "/usr/lib/dde-dock/tmp"); do
      substituteInPlace $file --replace-fail "/usr/lib/dde-dock/tmp" "/run/current-system/sw/lib/dde-dock/tmp"
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
    dtk6declarative
    dtk6widget
    dde-qt-dbus-factory
    qt6Packages.qtbase
    qt6Packages.qtwayland
    qt6Packages.qtsvg
    qt6platform-plugins
    kdePackages.networkmanager-qt
    wayland
    wayland-protocols
    yaml-cpp
    xorg.libXcursor
    xorg.libXres
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  cmakeFlags = [ "-DQML_INSTALL_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtQmlPrefix}" ];

  qtWrapperArgs = [
    # qt6integration must be placed before qtsvg in QT_PLUGIN_PATH
    "--prefix QT_PLUGIN_PATH : ${qt6integration}/${qt6Packages.qtbase.qtPluginPrefix}"
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
