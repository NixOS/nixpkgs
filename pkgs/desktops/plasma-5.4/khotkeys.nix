{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kdbusaddons, kdelibs4support, kglobalaccel, ki18n, kio, kxmlgui
, plasma-framework, plasma-workspace, qtx11extras
}:

plasmaPackage {
  name = "khotkeys";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kdbusaddons kxmlgui
  ];
  propagatedBuildInputs = [
    kdelibs4support kglobalaccel ki18n kio plasma-framework
    plasma-workspace qtx11extras
  ];
}
