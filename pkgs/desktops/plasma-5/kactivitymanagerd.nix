{
  mkDerivation, lib,
  extra-cmake-modules,
  boost, kconfig, kcoreaddons, kdbusaddons, ki18n, kio, kglobalaccel,
  kwindowsystem, kxmlgui, kcrash, qtbase
}:

mkDerivation {
  name = "kactivitymanagerd";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kconfig kcoreaddons kdbusaddons kglobalaccel ki18n kio kwindowsystem
    kxmlgui kcrash
  ];
}
