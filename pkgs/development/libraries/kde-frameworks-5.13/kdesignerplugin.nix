{ mkDerivation, lib
, extra-cmake-modules
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdewebkit
, kdoctools
, kiconthemes
, kio
, kitemviews
, kplotting
, ktextwidgets
, kwidgetsaddons
, kxmlgui
, sonnet
}:

mkDerivation {
  name = "kdesignerplugin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kdewebkit
    kiconthemes kio kitemviews kplotting ktextwidgets kwidgetsaddons
    kxmlgui sonnet
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
