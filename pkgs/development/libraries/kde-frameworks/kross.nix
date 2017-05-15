{ mkDerivation, lib, extra-cmake-modules, kcompletion, kcoreaddons
, kdoctools, ki18n, kiconthemes, kio, kparts, kwidgetsaddons
, kxmlgui, qtscript
}:

mkDerivation {
  name = "kross";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcompletion kcoreaddons ki18n kiconthemes kio kparts kwidgetsaddons kxmlgui
    qtscript
  ];
}
