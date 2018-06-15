{
  mkDerivation, extra-cmake-modules, shared-mime-info,
  bluez-qt, kcoreaddons, kdbusaddons, kded, ki18n, kiconthemes, kio,
  knotifications, kwidgetsaddons, kwindowsystem, plasma-framework, qtdeclarative
}:

mkDerivation {
  name = "bluedevil";
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    bluez-qt ki18n kio kwindowsystem plasma-framework qtdeclarative kcoreaddons
    kdbusaddons kded kiconthemes knotifications kwidgetsaddons
  ];
}
