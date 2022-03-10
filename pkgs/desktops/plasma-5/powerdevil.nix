{
  mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools,
  bluez-qt, kactivities, kauth, kconfig, kdbusaddons,
  kglobalaccel, ki18n, kidletime, kio, knotifyconfig, kwayland, libkscreen,
  ddcutil, networkmanager-qt, plasma-workspace, qtx11extras, solid, udev
}:

mkDerivation {
  pname = "powerdevil";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev bluez-qt kactivities kauth
    kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
    ddcutil
  ];
  cmakeFlags = [
    "-DHAVE_DDCUTIL=On"
  ];
}
