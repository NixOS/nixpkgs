{ plasmaPackage, ecm, kdoctools, bluez-qt, kactivities
, kauth, kconfig, kdbusaddons, kdelibs4support, kglobalaccel, ki18n
, kidletime, kio, knotifyconfig, kwayland, libkscreen, networkmanager-qt
, plasma-workspace, qtx11extras, solid, udev
}:

plasmaPackage {
  name = "powerdevil";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev bluez-qt kactivities kauth
    kdelibs4support kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
  ];
}
