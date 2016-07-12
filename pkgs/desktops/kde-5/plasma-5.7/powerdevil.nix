{ plasmaPackage, extra-cmake-modules, bluez-qt, kdoctools, kactivities
, kauth, kconfig, kdbusaddons, kdelibs4support, kglobalaccel, ki18n
, kidletime, kio, knotifyconfig, kwayland, libkscreen, networkmanager-qt, plasma-workspace
, qtx11extras, solid, udev
}:

plasmaPackage {
  name = "powerdevil";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    bluez-qt kconfig kdbusaddons knotifyconfig solid udev kactivities kauth
    kdelibs4support kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
  ];
}
