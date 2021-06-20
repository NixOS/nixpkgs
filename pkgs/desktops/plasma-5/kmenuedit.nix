{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kdbusaddons, khotkeys, ki18n, kiconthemes, kio, kxmlgui,
  sonnet
}:

mkDerivation {
  name = "kmenuedit";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdbusaddons khotkeys ki18n kiconthemes kio kxmlgui sonnet
  ];
}
