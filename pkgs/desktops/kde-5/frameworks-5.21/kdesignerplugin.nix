{ kdeFramework, lib, makeQtWrapper
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
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kdewebkit kiconthemes kio
    kitemviews kplotting ktextwidgets kwidgetsaddons kxmlgui sonnet
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kgendesignerplugin"
  '';
}
