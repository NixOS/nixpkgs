{ plasmaPackage, extra-cmake-modules, kdoctools, kactivities
, kauth, kconfig, kdbusaddons, kdelibs4support, kglobalaccel, ki18n
, kidletime, kio, knotifyconfig, kwayland, libkscreen, plasma-workspace
, qtx11extras, solid, udev
}:

plasmaPackage {
  name = "powerdevil";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev kactivities kauth
    kdelibs4support kglobalaccel ki18n kio kidletime kwayland libkscreen
    plasma-workspace qtx11extras
  ];
}
