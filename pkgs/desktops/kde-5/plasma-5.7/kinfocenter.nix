{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons
, kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kpackage
, kservice, kwidgetsaddons, kxmlgui, libraw1394, makeQtWrapper
, pciutils, solid
}:

plasmaPackage {
  name = "kinfocenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kdeclarative kdelibs4support ki18n kio kcmutils kcompletion kconfig
    kconfigwidgets kcoreaddons kdbusaddons kiconthemes kpackage kservice
    kwidgetsaddons kxmlgui libraw1394 pciutils solid
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kinfocenter"
  '';
}
