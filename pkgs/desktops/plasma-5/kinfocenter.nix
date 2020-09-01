{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcmutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kirigami2, kpackage,
  kservice, kwayland, kwidgetsaddons, kxmlgui, libraw1394, libGLU, pciutils,
  solid
}:

mkDerivation {
  name = "kinfocenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kdelibs4support ki18n kiconthemes kio kirigami2 kpackage
    kservice kwayland kwidgetsaddons kxmlgui libraw1394 libGLU pciutils solid
  ];
}
