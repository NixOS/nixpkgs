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
, kquickcharts
, ksystemstats
, qqc2-desktop-style
, qtbase
}:

mkDerivation {
  pname = "plasma-systemmonitor";
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
    kquickcharts
    ksystemstats
    qqc2-desktop-style
  ];
}
