{ plasmaPackage
, extra-cmake-modules
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
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kdbusaddons kwidgetsaddons kcoreaddons kcrash kconfig ki18n kiconthemes
    knotifications kwindowsystem polkit-qt
  ];
}
