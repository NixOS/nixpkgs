{ automoc4, cmake, kde, kdelibs, qt4, strigi, qimageblitz, libdbusmenu_qt
, xorg, soprano, shared_desktop_ontologies, lm_sensors, pciutils, libraw1394
, libusb, libxklavier, perl, python, libqalculate, akonadi
}:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 strigi qimageblitz libdbusmenu_qt
      xorg.libxkbfile xorg.libXcomposite xorg.libXScrnSaver xorg.libXtst
      xorg.libXcomposite xorg.libXdamage xorg.libXau
      soprano shared_desktop_ontologies lm_sensors pciutils libraw1394
      libusb python libqalculate akonadi
    ];

  # Workaround for ‘undefined reference to `dlsym'’ in kwinglutils_funcs.cpp.
  NIX_LDFLAGS = "-ldl";

  meta = {
    description = "KDE workspace components such as Plasma, Kwin and System Settings";
    license = "GPLv2";
    kde.name = "kde-workspace";
  };
}
