{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  bluez-qt, kactivities, kauth, kconfig, kdbusaddons, kdelibs4support,
  kglobalaccel, ki18n, kidletime, kio, knotifyconfig, kwayland, libkscreen,
  networkmanager-qt, plasma-workspace, qtx11extras, solid, udev
}:

mkDerivation {
  name = "powerdevil";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev bluez-qt kactivities kauth
    kdelibs4support kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
  ];
}
