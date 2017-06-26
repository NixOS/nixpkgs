{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kdbusaddons, kdelibs4support, khotkeys, ki18n, kiconthemes, kio, kxmlgui,
  sonnet
}:

mkDerivation {
  name = "kmenuedit";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdbusaddons kdelibs4support khotkeys ki18n kiconthemes kio kxmlgui sonnet
  ];
}
