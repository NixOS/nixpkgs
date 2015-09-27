{ mkDerivation
, extra-cmake-modules
, kdoctools
, kactivities
, kauth
, kconfig
, kdbusaddons
, kdelibs4support
, kglobalaccel
, ki18n
, kidletime
, kio
, knotifyconfig
, libkscreen
, plasma-workspace
, qtx11extras
, solid
, udev
}:

mkDerivation {
  name = "powerdevil";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kactivities
    kauth
    kconfig
    kdbusaddons
    kdelibs4support
    kglobalaccel
    ki18n
    kidletime
    kio
    knotifyconfig
    libkscreen
    plasma-workspace
    qtx11extras
    solid
    udev
  ];
}
