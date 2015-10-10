{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons
, kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kpackage
, kservice, kwidgetsaddons, kxmlgui, libraw1394, pciutils, solid
}:

plasmaPackage {
  name = "kinfocenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons ki18n kiconthemes kio kpackage kservice kwidgetsaddons
    kxmlgui libraw1394 pciutils solid
  ];
  propagatedBuildInputs = [ kdeclarative kdelibs4support ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kinfocenter"
  '';
}
