{ plasmaPackage
, ecm
, ki18n
, kwindowsystem
, kdbusaddons
, kwidgetsaddons
, kcoreaddons
, kcrash
, kconfig
, kiconthemes
, knotifications
, polkit-qt
}:

plasmaPackage {
  name = "polkit-kde-agent";
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    kdbusaddons kwidgetsaddons kcoreaddons kcrash kconfig ki18n kiconthemes
    knotifications kwindowsystem polkit-qt
  ];
}
