{
  mkDerivation, lib, fetchpatch,

  extra-cmake-modules, kdoctools,

  coreutils, dbus, gnugrep, gnused, isocodes, libdbusmenu, libSM, libXcursor,
  libXtst, pam, wayland, xmessage, xprop, xrdb, xsetroot,

  baloo, breeze-qt5, kactivities, kactivities-stats, kcmutils, kconfig, kcrash,
  kdbusaddons, kdeclarative, kdelibs4support, kdesu, kglobalaccel, kidletime,
  kinit, kjsembed, knewstuff, knotifyconfig, kpackage, kpeople, krunner,
  kscreenlocker, ktexteditor, ktextwidgets, kwallet, kwayland, kwin,
  kxmlrpcclient, libkscreen, libksysguard, libqalculate, networkmanager-qt,
  phonon, plasma-framework, prison, solid, kholidays, kquickcharts,
  appstream-qt,

  qtgraphicaleffects, qtquickcontrols, qtquickcontrols2, qtscript, qttools,
  qtwayland, qtx11extras,
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  name = "plasma-workspace";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    isocodes libdbusmenu libSM libXcursor libXtst pam wayland

    baloo kactivities kactivities-stats kcmutils kconfig kcrash kdbusaddons
    kdeclarative kdelibs4support kdesu kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage kpeople krunner kscreenlocker ktexteditor
    ktextwidgets kwallet kwayland kwin kxmlrpcclient libkscreen libksysguard
    libqalculate networkmanager-qt phonon plasma-framework prison solid
    kholidays kquickcharts appstream-qt

    qtgraphicaleffects qtquickcontrols qtquickcontrols2 qtscript qtwayland qtx11extras
  ];
  propagatedUserEnvPkgs = [ qtgraphicaleffects ];
  outputs = [ "out" "dev" ];

  cmakeFlags = [
    ''-DNIXPKGS_BREEZE_WALLPAPERS=${getBin breeze-qt5}/share/wallpapers''
  ];

  patches = [
    ./0001-startkde.patch
    ./0002-absolute-wallpaper-install-dir.patch
    ( # Systemd v246 hides the interface used by KDE to fetch the
      # user session details.
      # We're applying this commit from 5.19.90 upgrading the
      # systementry applet to use the new sessionmanagement API.
      # See https://github.com/NixOS/nixpkgs/issues/98141 for more
      # details.
      # /!\ Remove this patch for version >= v5.19.90
      fetchpatch {
      name = "0003-port-systementry-to-sessionmanagement-api.patch";
      url = "https://invent.kde.org/plasma/plasma-workspace/-/commit/05414ed58d43d87d907326636faac53ae2e7bd60.patch";
      sha256 = "16izfcwxjkdn99j777ywjkzl01iyl542h4hpsbpkckccj7hz8sin";
    })
  ];

  postPatch = ''
    substituteInPlace wallpapers/image/wallpaper.knsrc.cmake \
      --replace '@QtBinariesDir@/qdbus' ${getBin qttools}/bin/qdbus
  '';

  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_XMESSAGE="${getBin xmessage}/bin/xmessage"''
    ''-DNIXPKGS_XRDB="${getBin xrdb}/bin/xrdb"''
    ''-DNIXPKGS_XSETROOT="${getBin xsetroot}/bin/xsetroot"''
    ''-DNIXPKGS_XPROP="${getBin xprop}/bin/xprop"''
    ''-DNIXPKGS_DBUS_UPDATE_ACTIVATION_ENVIRONMENT="${getBin dbus}/bin/dbus-update-activation-environment"''
    ''-DNIXPKGS_START_KDEINIT_WRAPPER="${getLib kinit}/libexec/kf5/start_kdeinit_wrapper"''
    ''-DNIXPKGS_KDEINIT5_SHUTDOWN="${getBin kinit}/bin/kdeinit5_shutdown"''
  ];
}
