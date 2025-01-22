{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  dtkwidget,
  dde-qt-dbus-factory,
  xorg,
  xscreensaver,
}:

stdenv.mkDerivation rec {
  pname = "deepin-screensaver";
  version = "5.0.18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-7lyHPE/x7rmwh7FtCPkuA8JgYpy90jRXhUWoaeZpVag=";
  };

  postPatch = ''
    patchShebangs {src,customscreensaver/deepin-custom-screensaver}/{generate_translations.sh,update_translations.sh}

    substituteInPlace src/{dbusscreensaver.cpp,com.deepin.ScreenSaver.service,src.pro} \
      customscreensaver/deepin-custom-screensaver/deepin-custom-screensaver.pro \
      --replace "/usr" "$out" \
      --replace "/etc" "$out/etc"

    substituteInPlace tools/preview/main.cpp \
      --replace "/usr/lib/xscreensaver" "${xscreensaver}/libexec/xscreensaver"
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtx11extras
    libsForQt5.qtdeclarative
    dtkwidget
    dde-qt-dbus-factory
    xorg.libXScrnSaver
  ];

  qmakeFlags = [
    "XSCREENSAVER_DATA_PATH=${xscreensaver}/libexec/xscreensaver"
    "COMPILE_ON_V23=true"
  ];

  meta = with lib; {
    description = "Screensaver service developed by deepin";
    mainProgram = "deepin-screensaver";
    homepage = "https://github.com/linuxdeepin/deepin-screensaver";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
