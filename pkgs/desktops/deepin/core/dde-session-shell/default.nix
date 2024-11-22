{
  stdenv,
  lib,
  fetchFromGitHub,
  linkFarm,
  cmake,
  pkg-config,
  libsForQt5,
  wrapGAppsHook3,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  deepin-pw-check,
  gsettings-qt,
  lightdm_qt,
  linux-pam,
  xorg,
  gtest,
  xkeyboard_config,
  dbus,
  dde-session-shell,
}:

stdenv.mkDerivation rec {
  pname = "dde-session-shell";
  version = "6.0.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-v0+Bz6J77Kgf4YV1iDhCqhmcNn493GFq1IEQbXBAVUU=";
  };

  postPatch = ''
    substituteInPlace scripts/lightdm-deepin-greeter files/wayland/lightdm-deepin-greeter-wayland \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace src/session-widgets/auth_module.h \
      --replace "/usr/lib/dde-control-center" "/run/current-system/sw/lib/dde-control-center"

    substituteInPlace src/global_util/modules_loader.cpp \
      --replace "/usr/lib/dde-session-shell/modules" "/run/current-system/sw/lib/dde-session-shell/modules"

    substituteInPlace src/{session-widgets/{lockcontent.cpp,userinfo.cpp},widgets/fullscreenbackground.cpp} \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds"

    substituteInPlace src/global_util/xkbparser.h \
      --replace "/usr/share/X11/xkb/rules/base.xml" "${xkeyboard_config}/share/X11/xkb/rules/base.xml"

    substituteInPlace files/{org.deepin.dde.ShutdownFront1.service,org.deepin.dde.LockFront1.service} \
      --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send" \
      --replace "/usr/share" "$out/share"

    substituteInPlace src/global_util/{public_func.cpp,constants.h} scripts/lightdm-deepin-greeter files/{dde-lock.desktop,lightdm-deepin-greeter.desktop,wayland/lightdm-deepin-greeter-wayland.desktop} \
      --replace "/usr" "$out"

    patchShebangs files/deepin-greeter
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    wrapGAppsHook3
  ];
  dontWrapGApps = true;

  buildInputs = [
    libsForQt5.qtbase
    dtkwidget
    qt5integration
    qt5platform-plugins
    deepin-pw-check
    gsettings-qt
    lightdm_qt
    libsForQt5.qtx11extras
    linux-pam
    xorg.libXcursor
    xorg.libXtst
    xorg.libXrandr
    xorg.libXdmcp
    gtest
  ];

  outputs = [
    "out"
    "dev"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.xgreeters = linkFarm "deepin-greeter-xgreeters" [
    {
      path = "${dde-session-shell}/share/xgreeters/lightdm-deepin-greeter.desktop";
      name = "lightdm-deepin-greeter.desktop";
    }
  ];

  meta = with lib; {
    description = "Deepin desktop-environment - session-shell module";
    homepage = "https://github.com/linuxdeepin/dde-session-shell";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
