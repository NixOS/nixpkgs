{ kdeFramework, lib, extra-cmake-modules, kcompletion, kcoreaddons
, kdoctools, ki18n, kiconthemes, kio, kparts, kwidgetsaddons
, kxmlgui, qtscript
}:

kdeFramework {
  name = "kross";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcompletion kcoreaddons kxmlgui ];
  propagatedBuildInputs = [ ki18n kiconthemes kio kparts kwidgetsaddons qtscript ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
