{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfig, kconfigwidgets, kcoreaddons, kiconthemes, kio,
  kitemviews, kplotting, ktextwidgets, kwidgetsaddons, kxmlgui, sonnet
}:

mkDerivation {
  name = "kdesignerplugin";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kiconthemes kio
    kitemviews kplotting ktextwidgets kwidgetsaddons kxmlgui sonnet
  ];
}
