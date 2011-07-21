{ automoc4, cmake, kde, kdelibs, qt4, strigi, qimageblitz, libdbusmenu_qt
, xorg, soprano, shared_desktop_ontologies, lm_sensors, pciutils, libraw1394
, libusb, libxklavier, perl, python, libqalculate, akonadi, consolekit
, phonon, xkeyboard_config, kdepimlibs
}:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 strigi qimageblitz libdbusmenu_qt
      xorg.libxkbfile xorg.libXcomposite xorg.libXScrnSaver xorg.libXtst
      xorg.libXcomposite xorg.libXdamage xorg.libXau xorg.libXdmcp
      xorg.libpthreadstubs
      soprano shared_desktop_ontologies lm_sensors pciutils libraw1394
      libusb python libqalculate akonadi perl consolekit phonon
      kdepimlibs
    ];

  preConfigure =
   ''
     # Fix incorrect path to kde4-config.
     substituteInPlace startkde.cmake --replace '$bindir/kde4-config' ${kdelibs}/bin/kde4-config

     # Fix the path to the keyboard configuration files.
     substituteInPlace kcontrol/keyboard/xkb_rules.cpp \
       --replace /usr/share/X11 ${xkeyboard_config}/etc/X11
   '';

  meta = {
    description = "KDE workspace components such as Plasma, Kwin and System Settings";
    license = "GPLv2";
    kde.name = "kde-workspace";
  };
}
