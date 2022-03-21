{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kdbusaddons, khotkeys, ki18n, kiconthemes, kio, kxmlgui,
  sonnet
}:

mkDerivation {
  pname = "kmenuedit";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdbusaddons khotkeys ki18n kiconthemes kio kxmlgui sonnet
  ];
}
