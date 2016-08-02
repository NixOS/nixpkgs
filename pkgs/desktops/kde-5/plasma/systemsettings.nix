{
  plasmaPackage, ecm, kdoctools, makeQtWrapper,
  kcmutils, kconfig, kdbusaddons, khtml, ki18n, kiconthemes, kio, kitemviews,
  kservice, kwindowsystem, kxmlgui, qtquickcontrols
}:

plasmaPackage {
  name = "systemsettings";
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kcmutils kconfig kdbusaddons khtml ki18n kiconthemes kio kitemviews kservice
    kwindowsystem kxmlgui qtquickcontrols
  ];
}
