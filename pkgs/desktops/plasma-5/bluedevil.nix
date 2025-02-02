{
  mkDerivation,
  extra-cmake-modules,
  shared-mime-info,
  qtbase,
  qtdeclarative,
  bluez-qt,
  kcoreaddons,
  kcmutils,
  kdbusaddons,
  kded,
  ki18n,
  kiconthemes,
  kio,
  knotifications,
  kwidgetsaddons,
  kwindowsystem,
  plasma-framework,
}:

mkDerivation {
  pname = "bluedevil";
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    qtbase
    qtdeclarative
    bluez-qt
    ki18n
    kio
    kwindowsystem
    plasma-framework
    kcoreaddons
    kdbusaddons
    kded
    kiconthemes
    knotifications
    kwidgetsaddons
    kcmutils
  ];
}
