{
  stdenv,
  lib,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  qttools,
  pkg-config,
  wrapQtAppsHook,
  wrapGAppsHook3,
  qtbase,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dwayland,
  qtx11extras,
  gsettings-qt,
  libdbusmenu,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "dde-dock";
  version = "6.0.35";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-ATC/Ze6GyjT92eCgAt9g2FIQbXLVHUMuXuAslNnbkCE=";
  };

  postPatch = ''
    substituteInPlace plugins/pluginmanager/pluginmanager.cpp frame/controller/quicksettingcontroller.cpp  \
      --replace "/usr/lib/dde-dock" "/run/current-system/sw/lib/dde-dock"

    substituteInPlace configs/com.deepin.dde.dock.json frame/util/common.h \
    --replace "/usr" "/run/current-system/sw"

    for file in $(grep -rl "/usr/lib/deepin-daemon"); do
      substituteInPlace $file --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"
    done
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  dontWrapGApps = true;

  buildInputs = [
    qtbase
    dtkwidget
    qt5platform-plugins
    dwayland
    qtx11extras
    gsettings-qt
    libdbusmenu
    xorg.libXcursor
    xorg.libXtst
    xorg.libXdmcp
    xorg.libXres
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Deepin desktop-environment - dock module";
    mainProgram = "dde-dock";
    homepage = "https://github.com/linuxdeepin/dde-dock";
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
    maintainers = teams.deepin.members;
  };
}
