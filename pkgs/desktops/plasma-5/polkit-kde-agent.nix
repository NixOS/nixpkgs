{
  mkDerivation, lib, extra-cmake-modules,
  kcoreaddons, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, knotifications,
  kwidgetsaddons, kwindowsystem, polkit-qt, qtbase
}:

mkDerivation {
  name = "polkit-kde-agent";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kdbusaddons kwidgetsaddons kcoreaddons kcrash kconfig ki18n kiconthemes
    knotifications kwindowsystem polkit-qt
  ];
  outputs = [ "out" "dev" ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
