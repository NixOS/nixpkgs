{
  plasmaPackage, ecm,
  kcoreaddons, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, knotifications,
  kwidgetsaddons, kwindowsystem, polkit-qt
}:

plasmaPackage {
  name = "polkit-kde-agent";
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kdbusaddons kwidgetsaddons kcoreaddons kcrash kconfig ki18n kiconthemes
    knotifications kwindowsystem polkit-qt
  ];
}
