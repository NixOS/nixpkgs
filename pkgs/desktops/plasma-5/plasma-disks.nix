{
  mkDerivation, extra-cmake-modules, kdoctools,
  kcmutils, kconfig, kdbusaddons, khtml, ki18n, kiconthemes, kio, kitemviews,
  kservice, kwindowsystem, kxmlgui, qtquickcontrols, qtquickcontrols2,
  kactivities, kactivities-stats, kirigami2, kcrash, plasma-workspace,
  systemsettings
}:

mkDerivation {
  name = "plasma-disks";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kconfig kdbusaddons khtml ki18n kiconthemes kio kitemviews kservice
    kwindowsystem kxmlgui qtquickcontrols qtquickcontrols2
    kactivities kactivities-stats kirigami2 kcrash plasma-workspace
    systemsettings
  ];
  outputs = [ "bin" "dev" "out" ];
}
