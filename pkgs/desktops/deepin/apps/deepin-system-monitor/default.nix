{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  deepin-gettext-tools,
  libsForQt5,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dde-qt-dbus-factory,
  dde-tray-loader,
  gsettings-qt,
  procps,
  libpcap,
  libnl,
  util-linux,
  systemd,
  polkit,
  wayland,
  dwayland,
}:

stdenv.mkDerivation rec {
  pname = "deepin-system-monitor";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-UOF0/RBceuRX6AtI1p5qqHhbRDAhA7i0+seOrkAFFgI=";
  };

  postPatch = ''
    substituteInPlace deepin-system-monitor-main/process/process_controller.cpp \
      deepin-system-monitor-main/process/priority_controller.cpp \
      deepin-system-monitor-main/service/service_manager.cpp \
      deepin-system-monitor-main/translations/policy/com.deepin.pkexec.deepin-system-monitor.policy \
        --replace "/usr/bin/kill" "${lib.getBin util-linux}/bin/kill" \
        --replace "/usr/bin/renice" "${lib.getBin util-linux}/bin/renice" \
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
    libsForQt5.qttools
    deepin-gettext-tools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qtx11extras
    dde-qt-dbus-factory
    dde-tray-loader
    gsettings-qt
    libsForQt5.polkit-qt
    procps
    libpcap
    libnl
    wayland
    dwayland
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = with lib; {
    description = "More user-friendly system monitor";
    homepage = "https://github.com/linuxdeepin/deepin-system-monitor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
