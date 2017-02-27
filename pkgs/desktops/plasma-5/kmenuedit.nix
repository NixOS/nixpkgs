{
  plasmaPackage,
  extra-cmake-modules, kdoctools,
  kdbusaddons, kdelibs4support, khotkeys, ki18n, kiconthemes, kio, kxmlgui,
  sonnet
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kdbusaddons kdelibs4support khotkeys ki18n kiconthemes kio kxmlgui sonnet
  ];
}
