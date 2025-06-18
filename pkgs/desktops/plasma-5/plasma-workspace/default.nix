{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  wayland-scanner,
  isocodes,
  libdbusmenu,
  libSM,
  libXcursor,
  libXtst,
  libXft,
  pam,
  wayland,
  xmessage,
  xsetroot,
  baloo,
  breeze-qt5,
  kactivities,
  kactivities-stats,
  kcmutils,
  kconfig,
  kcrash,
  kdbusaddons,
  kdeclarative,
  kdelibs4support,
  kdesu,
  kglobalaccel,
  kidletime,
  kinit,
  kjsembed,
  knewstuff,
  knotifyconfig,
  kpackage,
  kpeople,
  krunner,
  kscreenlocker,
  ktexteditor,
  ktextwidgets,
  kwallet,
  kwayland,
  kwin,
  kxmlrpcclient,
  libkscreen,
  libksysguard,
  libqalculate,
  networkmanager-qt,
  phonon,
  plasma-framework,
  prison,
  solid,
  kholidays,
  kquickcharts,
  appstream-qt,
  plasma-wayland-protocols,
  kpipewire,
  libkexiv2,
  kuserfeedback,
  qtgraphicaleffects,
  qtquickcontrols,
  qtquickcontrols2,
  qtscript,
  qttools,
  qtwayland,
  qtx11extras,
  qqc2-desktop-style,
  polkit-qt,
  pipewire,
  libdrm,
  fetchpatch,
}:

let
  inherit (lib) getBin getLib;
in

mkDerivation {
  pname = "plasma-workspace";
  passthru.providedSessions = [
    "plasma"
    "plasmawayland"
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wayland-scanner
  ];
  buildInputs = [
    isocodes
    libdbusmenu
    libSM
    libXcursor
    libXtst
    libXft
    pam
    wayland

    baloo
    kactivities
    kactivities-stats
    kcmutils
    kconfig
    kcrash
    kdbusaddons
    kdeclarative
    kdelibs4support
    kdesu
    kglobalaccel
    kidletime
    kjsembed
    knewstuff
    knotifyconfig
    kpackage
    kpeople
    krunner
    kscreenlocker
    ktexteditor
    ktextwidgets
    kwallet
    kwayland
    kwin
    kxmlrpcclient
    libkscreen
    libksysguard
    libqalculate
    networkmanager-qt
    phonon
    plasma-framework
    prison
    solid
    kholidays
    kquickcharts
    appstream-qt
    plasma-wayland-protocols
    kpipewire
    libkexiv2

    kuserfeedback
    qtgraphicaleffects
    qtquickcontrols
    qtquickcontrols2
    qtscript
    qtwayland
    qtx11extras
    qqc2-desktop-style
    polkit-qt

    pipewire
    libdrm
  ];
  propagatedUserEnvPkgs = [ qtgraphicaleffects ];
  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    ''-DNIXPKGS_BREEZE_WALLPAPERS=${getBin breeze-qt5}/share/wallpapers''
  ];

  patches = [
    ./0001-startkde.patch
    ./0002-absolute-wallpaper-install-dir.patch

    # Backport patch for cleaner shutdowns
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-workspace/-/commit/6ce8f434139f47e6a71bf0b68beae92be8845ce4.patch";
      hash = "sha256-cYw/4/9tSnCbArLr72O8F8V0NLkVXdCVnJGoGxSzZMg=";
    })
  ];

  # QT_INSTALL_BINS refers to qtbase, and qdbus is in qttools
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'ecm_query_qt(QtBinariesDir QT_INSTALL_BINS)' 'set(QtBinariesDir "${lib.getBin qttools}/bin")'
  '';

  # work around wrapQtAppsHook double-wrapping kcminit_startup,
  # which is a symlink to kcminit
  postFixup = ''
    ln -sf $out/bin/kcminit $out/bin/kcminit_startup
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    ''-DNIXPKGS_XMESSAGE="${getBin xmessage}/bin/xmessage"''
    ''-DNIXPKGS_XSETROOT="${getBin xsetroot}/bin/xsetroot"''
    ''-DNIXPKGS_START_KDEINIT_WRAPPER="${getLib kinit}/libexec/kf5/start_kdeinit_wrapper"''
    ''-DNIXPKGS_KDEINIT5_SHUTDOWN="${getBin kinit}/bin/kdeinit5_shutdown"''
  ];
}
