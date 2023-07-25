{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, deepin-gettext-tools
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtbase
, qtsvg
, qtx11extras
, dde-qt-dbus-factory
, dde-dock
, gsettings-qt
, procps
, libpcap
, libnl
, util-linux
, systemd
, polkit
}:

stdenv.mkDerivation rec {
  pname = "deepin-system-monitor";
  version = "5.9.33";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-X7/YwnJyA/HOLsOGARjsHWgL2qxW1eU1TvoWulvz0j4=";
  };

  postPatch = ''
    substituteInPlace deepin-system-monitor-main/process/process_controller.cpp \
      deepin-system-monitor-main/process/priority_controller.cpp \
      deepin-system-monitor-main/service/service_manager.cpp \
      deepin-system-monitor-main/translations/policy/com.deepin.pkexec.deepin-system-monitor.policy \
        --replace "/usr/bin/kill" "${util-linux}/bin/kill" \
        --replace "/usr/bin/renice" "${util-linux}/bin/renice" \
        --replace '/usr/bin/systemctl' '${lib.getBin systemd}/systemctl'

    substituteInPlace deepin-system-monitor-main/{service/service_manager.cpp,process/{priority_controller.cpp,process_controller.cpp}} \
      --replace "/usr/bin/pkexec" "${lib.getBin polkit}/bin/pkexec"

    for file in $(grep -rl "/usr")
    do
      substituteInPlace $file \
        --replace "/usr" "$out"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    deepin-gettext-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    qtx11extras
    dde-qt-dbus-factory
    dde-dock
    gsettings-qt
    procps
    libpcap
    libnl
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DUSE_DEEPIN_WAYLAND=OFF"
  ];

  strictDeps = true;

  meta = with lib; {
    description = "A more user-friendly system monitor";
    homepage = "https://github.com/linuxdeepin/deepin-system-monitor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
