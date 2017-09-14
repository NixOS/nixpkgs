{
  mkDerivation, extra-cmake-modules,
  kcoreaddons, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, knotifications,
  kwidgetsaddons, kwindowsystem, polkit-qt
}:

mkDerivation {
  name = "polkit-kde-agent";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kdbusaddons kwidgetsaddons kcoreaddons kcrash kconfig ki18n kiconthemes
    knotifications kwindowsystem polkit-qt
  ];
}
