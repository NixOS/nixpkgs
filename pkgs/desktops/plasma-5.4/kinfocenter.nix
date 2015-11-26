{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons
, kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kpackage
, kservice, kwidgetsaddons, kxmlgui, libraw1394, makeKDEWrapper
, pciutils, solid
}:

plasmaPackage {
  name = "kinfocenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeKDEWrapper
  ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons kiconthemes kpackage kservice kwidgetsaddons
    kxmlgui libraw1394 pciutils solid
  ];
  propagatedBuildInputs = [ kdeclarative kdelibs4support ki18n kio ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kinfocenter"
  '';
}
