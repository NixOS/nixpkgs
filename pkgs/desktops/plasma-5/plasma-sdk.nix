{ mkDerivation
, extra-cmake-modules
, karchive
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, ki18n
, kiconthemes
, kio
, kitemmodels
, plasma-framework
, kservice
, ktexteditor
, kwidgetsaddons
, kdoctools
, qtbase
}:

mkDerivation {
  pname = "plasma-sdk";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    ki18n
    kiconthemes
    kio
    kitemmodels
    plasma-framework
    kservice
    ktexteditor
    kwidgetsaddons
  ];
}
