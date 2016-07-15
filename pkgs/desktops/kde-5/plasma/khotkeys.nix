{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kdbusaddons, kdelibs4support, kglobalaccel, ki18n, kio, kxmlgui
, plasma-framework, plasma-workspace, qtx11extras
}:

plasmaPackage {
  name = "khotkeys";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kdelibs4support kglobalaccel ki18n kio plasma-framework plasma-workspace
    qtx11extras kcmutils kdbusaddons kxmlgui
  ];
}
