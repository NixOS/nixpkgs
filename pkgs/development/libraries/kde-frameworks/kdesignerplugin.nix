{ kdeFramework, lib
, ecm
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
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

kdeFramework {
  name = "kdesignerplugin";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kiconthemes kio
    kitemviews kplotting ktextwidgets kwidgetsaddons kxmlgui sonnet
  ];
}
