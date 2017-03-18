{
  plasmaPackage,
  extra-cmake-modules, kdoctools,
  lm_sensors,
  kconfig, kcoreaddons, kdelibs4support, ki18n, kiconthemes, kitemviews,
  knewstuff, libksysguard, qtwebkit
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ lm_sensors ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n qtwebkit
  ];
}
