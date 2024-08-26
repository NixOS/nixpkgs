{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  qtbase,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dde-dock,
  gsettings-qt,
  qtx11extras,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "dde-session-ui";
  version = "6.0.20";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-3twtJ1KT7TqpyLopHqPY2Lo8oZsH9liir0SJUV/k3OU=";
  };

  postPatch = ''
    substituteInPlace widgets/fullscreenbackground.cpp \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds" \
      --replace "/usr/share/wallpapers" "/run/current-system/sw/share/wallpapers"

    substituteInPlace dde-warning-dialog/src/org.deepin.dde.WarningDialog1.service dde-welcome/src/org.deepin.dde.Welcome1.service \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace dmemory-warning-dialog/src/org.deepin.dde.MemoryWarningDialog1.service \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    dtkwidget
    qt5platform-plugins
    dde-dock
    gsettings-qt
    qtx11extras
    gtest
  ];

  cmakeFlags = [ "-DDISABLE_SYS_UPDATE=ON" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [ "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}" ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    for binary in $out/lib/deepin-daemon/*; do
      wrapProgram $binary "''${qtWrapperArgs[@]}"
    done
  '';

  meta = with lib; {
    description = "Deepin desktop-environment - Session UI module";
    homepage = "https://github.com/linuxdeepin/dde-session-ui";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
