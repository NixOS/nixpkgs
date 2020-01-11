{
  mkDerivation, lib,

  extra-cmake-modules, kdoctools,

  coreutils, dbus, gnugrep, gnused, isocodes, libdbusmenu, libSM, libXcursor,
  libXtst, pam, wayland, xmessage, xprop, xrdb, xsetroot,

  baloo, kactivities, kcmutils, kconfig, kcrash, kdbusaddons, kdeclarative,
  kdelibs4support, kdesu, kglobalaccel, kidletime, kinit, kjsembed, knewstuff,
  knotifyconfig, kpackage, krunner, kscreenlocker, ktexteditor, ktextwidgets,
  kwallet, kwayland, kwin, kxmlrpcclient, libkscreen, libksysguard, libqalculate,
  networkmanager-qt, phonon, plasma-framework, prison, solid, kholidays,
  breeze-qt5,

  qtgraphicaleffects, qtquickcontrols, qtquickcontrols2, qtscript, qttools,
  qtwayland, qtx11extras,
}:

let inherit (lib) getBin getLib; in

mkDerivation {
  name = "plasma-workspace";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    isocodes libdbusmenu libSM libXcursor libXtst pam wayland

    baloo kactivities kcmutils kconfig kcrash kdbusaddons kdeclarative
    kdelibs4support kdesu kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage krunner kscreenlocker ktexteditor ktextwidgets
    kwallet kwayland kwin kxmlrpcclient libkscreen libksysguard libqalculate
    networkmanager-qt phonon plasma-framework prison solid kholidays

    qtgraphicaleffects qtquickcontrols qtquickcontrols2 qtscript qtwayland qtx11extras
  ];
  propagatedUserEnvPkgs = [ qtgraphicaleffects ];
  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DNIXPKGS_XMESSAGE=${getBin xmessage}/bin/xmessage"
    "-DNIXPKGS_MKDIR=${getBin coreutils}/bin/mkdir"
    "-DNIXPKGS_XRDB=${getBin xrdb}/bin/xrdb"
    "-DNIXPKGS_QTPATHS=${getBin qttools}/bin/qtpaths"
    "-DNIXPKGS_XSETROOT=${getBin xsetroot}/bin/xsetroot"
    "-DNIXPKGS_XPROP=${getBin xprop}/bin/xprop"
    "-DNIXPKGS_ID=${getBin coreutils}/bin/id"
    "-DNIXPKGS_DBUS_UPDATE_ACTIVATION_ENVIRONMENT=${getBin dbus}/bin/dbus-update-activation-environment"
    "-DNIXPKGS_START_KDEINIT_WRAPPER=${getLib kinit}/libexec/kf5/start_kdeinit_wrapper"
    "-DNIXPKGS_QDBUS=${getBin qttools}/bin/qdbus"
    "-DNIXPKGS_KWRAPPER5=${getBin kinit}/bin/kwrapper5"
    "-DNIXPKGS_KREADCONFIG5=${getBin kconfig}/bin/kreadconfig5"
    "-DNIXPKGS_GREP=${getBin gnugrep}/bin/grep"
    "-DNIXPKGS_KDEINIT5_SHUTDOWN=${getBin kinit}/bin/kdeinit5_shutdown"
    "-DNIXPKGS_SED=${getBin gnused}/bin/sed"
    "-DNIXPKGS_WALLPAPER_INSTALL_DIR=${getBin breeze-qt5}/share/wallpapers/"
  ];

  # To regenerate ./plasma-workspace.patch,
  #
  # > git clone https://github.com/ttuegel/plasma-workspace
  # > cd plasma-workspace
  # > git checkout nixpkgs/$x.$y  # where $x.$y.$z == $version
  # ... make some commits ...
  # > git diff v$x.$y.$z
  #
  # Add upstream patches to the list below. For new patchs, particularly if not
  # submitted upstream, please make a pull request and add it to
  # ./plasma-workspace.patch.
  patches = [
    ./plasma-workspace.patch
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_KDOSTARTUPCONFIG5=\"''${!outputBin}/bin/kdostartupconfig5\""
    cmakeFlags+=" -DNIXPKGS_STARTPLASMA=''${!outputBin}/libexec/startplasma"
  '';
}
