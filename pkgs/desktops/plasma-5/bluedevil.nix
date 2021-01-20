{
  mkDerivation, lib, extra-cmake-modules, shared-mime-info,
  qtbase, qtdeclarative, bluez-qt,
  kcoreaddons, kdbusaddons, kded, ki18n, kiconthemes, kio, knotifications,
  kwidgetsaddons, kwindowsystem, plasma-framework
}:

mkDerivation {
  name = "bluedevil";
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    qtbase qtdeclarative bluez-qt
    ki18n kio kwindowsystem plasma-framework kcoreaddons kdbusaddons kded
    kiconthemes knotifications kwidgetsaddons
  ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
