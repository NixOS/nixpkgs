{ mkDerivation
, extra-cmake-modules
, kauth
, kcompletion
, kconfigwidgets
, kcoreaddons
, kservice
, kwidgetsaddons
, kwindowsystem
, plasma-framework
, qtscript
, qtwebkit
, qtx11extras
, kconfig
, ki18n
, kiconthemes
}:

mkDerivation {
  name = "libksysguard";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kauth
    kcompletion
    kconfigwidgets
    kcoreaddons
    kservice
    kwidgetsaddons
    kwindowsystem
    plasma-framework
    qtscript
    qtwebkit
    qtx11extras
  ];
  propagatedBuildInputs = [
    kconfig
    ki18n
    kiconthemes
  ];
}
