{
  mkDerivation, lib,

  extra-cmake-modules, kdoctools,

  coreutils, gnugrep, gnused, isocodes, libdbusmenu, libSM, libXcursor,
  libXtst, libXft, pam, wayland, xmessage, xsetroot,

  baloo, breeze-qt5, kactivities, kactivities-stats, kcmutils, kconfig, kcrash,
  kdbusaddons, kdeclarative, kdelibs4support, kdesu, kglobalaccel, kidletime,
  kinit, kjsembed, knewstuff, knotifyconfig, kpackage, kpeople, krunner,
  kscreenlocker, ktexteditor, ktextwidgets, kwallet, kwayland, kwin,
  kxmlrpcclient, libkscreen, libksysguard, libqalculate, networkmanager-qt,
  phonon, plasma-framework, prison, solid, kholidays, kquickcharts,
  appstream-qt, plasma-wayland-protocols,

  qtgraphicaleffects, qtquickcontrols, qtquickcontrols2, qtscript, qttools,
  qtwayland, qtx11extras, qqc2-desktop-style,

  pipewire, libdrm
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  pname = "plasma-workspace";
  passthru.providedSessions = [ "plasma" "plasmawayland" ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    isocodes libdbusmenu libSM libXcursor libXtst libXft pam wayland

    baloo kactivities kactivities-stats kcmutils kconfig kcrash kdbusaddons
    kdeclarative kdelibs4support kdesu kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage kpeople krunner kscreenlocker ktexteditor
    ktextwidgets kwallet kwayland kwin kxmlrpcclient libkscreen libksysguard
    libqalculate networkmanager-qt phonon plasma-framework prison solid
    kholidays kquickcharts appstream-qt plasma-wayland-protocols

    qtgraphicaleffects qtquickcontrols qtquickcontrols2 qtscript qtwayland
    qtx11extras qqc2-desktop-style

    pipewire libdrm
  ];
  propagatedUserEnvPkgs = [ qtgraphicaleffects ];
  outputs = [ "out" "dev" ];

  cmakeFlags = [
    ''-DNIXPKGS_BREEZE_WALLPAPERS=${getBin breeze-qt5}/share/wallpapers''
  ];

  patches = [
    ./0001-startkde.patch
    ./0002-absolute-wallpaper-install-dir.patch
  ];

  # QT_INSTALL_BINS refers to qtbase, and qdbus is in qttools
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'ecm_query_qt(QtBinariesDir QT_INSTALL_BINS)' 'set(QtBinariesDir "${lib.getBin qttools}/bin")'
  '';

  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_XMESSAGE="${getBin xmessage}/bin/xmessage"''
    ''-DNIXPKGS_XSETROOT="${getBin xsetroot}/bin/xsetroot"''
    ''-DNIXPKGS_START_KDEINIT_WRAPPER="${getLib kinit}/libexec/kf5/start_kdeinit_wrapper"''
    ''-DNIXPKGS_KDEINIT5_SHUTDOWN="${getBin kinit}/bin/kdeinit5_shutdown"''
  ];
}
