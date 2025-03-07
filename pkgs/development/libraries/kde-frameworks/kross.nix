{ mkDerivation, extra-cmake-modules, kcompletion, kcoreaddons
, kdoctools, ki18n, kiconthemes, kio, kparts, kwidgetsaddons
, kxmlgui, qtbase, qtscript, qtxmlpatterns,
}:

mkDerivation {
  pname = "kross";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcompletion kcoreaddons kxmlgui ];
  propagatedBuildInputs = [
    ki18n kiconthemes kio kparts kwidgetsaddons qtbase qtscript qtxmlpatterns
  ];
}
