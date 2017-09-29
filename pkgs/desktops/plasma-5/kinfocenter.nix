{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcmutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kpackage, kservice,
  kwayland, kwidgetsaddons, kxmlgui, libraw1394, mesa_glu, pciutils, solid
}:

mkDerivation {
  name = "kinfocenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kdelibs4support ki18n kiconthemes kio kpackage kservice
    kwayland kwidgetsaddons kxmlgui libraw1394 mesa_glu pciutils solid
  ];
}
