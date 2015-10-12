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
, polkitQt
}:

plasmaPackage {
  name = "polkit-kde-agent";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    ki18n
    kwindowsystem
    kdbusaddons
    kwidgetsaddons
    kcoreaddons
    kcrash
    kconfig
    kiconthemes
    knotifications
    polkitQt
  ];
}
