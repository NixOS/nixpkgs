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
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kcoreaddons kdewebkit
    kiconthemes kitemviews kplotting ktextwidgets kwidgetsaddons
    kxmlgui
  ];
  propagatedBuildInputs = [ kio sonnet ];
  postInstall = ''
    wrapQtProgram "$out/bin/kgendesignerplugin"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
