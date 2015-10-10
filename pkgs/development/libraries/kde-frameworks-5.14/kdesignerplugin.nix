{ kdeFramework, lib
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

kdeFramework {
  name = "kdesignerplugin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kdewebkit
    kiconthemes kitemviews kplotting ktextwidgets kwidgetsaddons
    kxmlgui
  ];
  propagatedBuildInputs = [ kio sonnet ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
