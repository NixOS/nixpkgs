{ kde, kdelibs, qimageblitz, libdbusmenu_qt, xorg, lm_sensors
, pciutils, libraw1394, libusb, python, libqalculate, akonadi
, xkeyboard_config, kdepimlibs, pam, boost, gpsd, prison
, libjpeg, pkgconfig, kactivities, qjson, udev, fetchurl
}:

kde {
#todo: wayland, xmms, ckconnector
  buildInputs =
    [ kdelibs qimageblitz libdbusmenu_qt xorg.libxcb xorg.xcbutilimage libjpeg 
      xorg.xcbutilrenderutil xorg.xcbutilkeysyms xorg.libpthreadstubs xorg.libXdmcp
      xorg.libxkbfile xorg.libXcomposite  xorg.libXtst
      xorg.libXdamage

      python boost qjson lm_sensors gpsd libraw1394 pciutils udev
      akonadi pam libusb libqalculate kdepimlibs  prison
      kactivities
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

  enableParallelBuilding = false; # frequent problems on Hydra

  meta = {
    description = "KDE workspace components such as Plasma, Kwin and System Settings";
    license = "GPLv2";
  };
}
