{ mkDerivation, lib, extra-cmake-modules, kcompletion, kcoreaddons
, kdoctools, ki18n, kiconthemes, kio, kparts, kwidgetsaddons
, kxmlgui, qtbase, qtscript, qtxmlpatterns,
}:

mkDerivation {
  name = "kross";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcompletion kcoreaddons kxmlgui ];
  propagatedBuildInputs = [
    ki18n kiconthemes kio kparts kwidgetsaddons qtbase qtscript qtxmlpatterns
  ];
}
