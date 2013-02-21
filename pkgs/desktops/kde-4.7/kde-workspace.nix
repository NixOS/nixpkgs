{ kde, kdelibs, qimageblitz, libdbusmenu_qt, xorg, shared_desktop_ontologies
, lm_sensors, pciutils, libraw1394, libusb, libxklavier, python, libqalculate
, xkeyboard_config, kdepimlibs, pam, boost, gpsd, prison, akonadi
, pykde4, libjpeg, pkgconfig, libXft, libXxf86misc
}:

kde {

  buildInputs =
    [ kdelibs qimageblitz libdbusmenu_qt pykde4 libjpeg libXft libXxf86misc
      xorg.libxkbfile xorg.libXcomposite xorg.libXScrnSaver xorg.libXtst
      xorg.libXcomposite xorg.libXdamage xorg.libXau xorg.libXdmcp
      xorg.libpthreadstubs
      boost gpsd shared_desktop_ontologies lm_sensors pciutils libraw1394
      libusb python libqalculate kdepimlibs pam prison akonadi
    ];

  nativeBuildInputs = [ pkgconfig ];

  preConfigure =
   ''
     # Fix incorrect path to kde4-config.
     substituteInPlace startkde.cmake --replace '$bindir/kde4-config' ${kdelibs}/bin/kde4-config

     # Fix the path to the keyboard configuration files.
     substituteInPlace kcontrol/keyboard/xkb_rules.cpp \
       --replace /usr/share/X11 ${xkeyboard_config}/etc/X11
   '';

  enableParallelBuilding = false;
  
  meta = {
    description = "KDE workspace components such as Plasma, Kwin and System Settings";
    license = "GPLv2";
  };
}
