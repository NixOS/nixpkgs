{ kdeFramework, lib, makeQtWrapper
, extra-cmake-modules
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
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kiconthemes kio
    kitemviews kplotting ktextwidgets kwidgetsaddons kxmlgui sonnet
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kgendesignerplugin"
  '';
}
