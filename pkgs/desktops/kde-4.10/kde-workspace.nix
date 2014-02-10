{ kde, kdelibs, qimageblitz, libdbusmenu_qt, xorg, shared_desktop_ontologies,
  lm_sensors, pciutils, libraw1394, libusb, libxklavier, python, libqalculate,
  xkeyboard_config, kdepimlibs, pam, boost, gpsd, prison, akonadi,
  libjpeg, pkgconfig, libXft, libXxf86misc, kactivities, qjson, networkmanager,
  fetchurl
}:

kde {

#todo: googlegadgets, consolekit, xmms
  buildInputs =
    [ kdelibs qimageblitz libdbusmenu_qt libjpeg xorg.libxcb xorg.xcbutilimage
      xorg.xcbutilrenderutil libXft #libXxf86misc
      xorg.libxkbfile xorg.libXcomposite  xorg.libXtst #xorg.libXScrnSaver
      xorg.libXdamage xorg.libXau xorg.libXdmcp xorg.libpthreadstubs
      boost gpsd lm_sensors pciutils libraw1394
      libusb python libqalculate kdepimlibs pam prison akonadi qjson networkmanager
      kactivities
    ];

  patches = [(fetchurl {
    url = "https://git.reviewboard.kde.org/r/111261/diff/raw/";
    sha256 = "0g8qjna1s0imz7801k4iy2ap5z81izi4bncvks7z3n9agji4zf40";
    name = "CVE-2013-4132.patch";
  })];

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
