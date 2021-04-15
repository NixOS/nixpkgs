{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, qtquickcontrols2
, kconfig
, kcoreaddons
, ki18n
, kiconthemes
, kitemmodels
, kitemviews
, knewstuff
, libksysguard
, qtbase
}:

mkDerivation {
  name = "plasma-systemmonitor";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtquickcontrols2
    kconfig
    kcoreaddons
    ki18n
    kitemmodels
    kitemviews
    knewstuff
    kiconthemes
    libksysguard
  ];
}
