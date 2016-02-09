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
  buildInputs = [
    kdbusaddons
    kwidgetsaddons
    kcoreaddons
    kcrash
    kconfig
    kiconthemes
    knotifications
    polkit-qt
  ];
  propagatedBuildInputs = [ ki18n kwindowsystem ];
}
