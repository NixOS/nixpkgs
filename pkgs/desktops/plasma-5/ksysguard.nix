{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  lm_sensors,
  kconfig, kcoreaddons, kdelibs4support, ki18n, kiconthemes, kitemviews,
  knewstuff, libksysguard, qtwebkit
}:

mkDerivation {
  name = "ksysguard";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n lm_sensors qtwebkit
  ];
}
