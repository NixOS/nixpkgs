{ plasmaPackage, extra-cmake-modules, kdoctools, kactivities
, kauth, kconfig, kdbusaddons, kdelibs4support, kglobalaccel, ki18n
, kidletime, kio, knotifyconfig, libkscreen, plasma-workspace
, qtx11extras, solid, udev
}:

plasmaPackage {
  name = "powerdevil";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig kdbusaddons kglobalaccel ki18n
    kidletime kio knotifyconfig libkscreen plasma-workspace
    qtx11extras solid udev
  ];
  propagatedBuildInputs = [ kactivities kauth kdelibs4support ];
}
