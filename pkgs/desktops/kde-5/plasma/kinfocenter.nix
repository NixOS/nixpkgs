{
  plasmaPackage,
  ecm, kdoctools,
  kcmutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kpackage, kservice,
  kwayland, kwidgetsaddons, kxmlgui, libraw1394, mesa_glu, pciutils, solid
}:

plasmaPackage {
  name = "kinfocenter";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kdelibs4support ki18n kiconthemes kio kpackage kservice
    kwayland kwidgetsaddons kxmlgui libraw1394 mesa_glu pciutils solid
  ];
}
