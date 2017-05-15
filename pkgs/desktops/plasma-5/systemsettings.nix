{
  mkDerivation, extra-cmake-modules, kdoctools, makeQtWrapper,
  kcmutils, kconfig, kdbusaddons, khtml, ki18n, kiconthemes, kio, kitemviews,
  kservice, kwindowsystem, kxmlgui, qtquickcontrols, qtquickcontrols2
}:

mkDerivation {
  name = "systemsettings";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcmutils kconfig kdbusaddons khtml ki18n kiconthemes kio kitemviews kservice
    kwindowsystem kxmlgui qtquickcontrols qtquickcontrols2
  ];
}
