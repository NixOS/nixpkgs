{
  plasmaPackage,
  ecm, kdoctools,
  kdbusaddons, kdelibs4support, khotkeys, ki18n, kiconthemes, kio, kxmlgui,
  sonnet
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kdbusaddons kdelibs4support khotkeys ki18n kiconthemes kio kxmlgui sonnet
  ];
}
