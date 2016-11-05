{
  plasmaPackage,
  ecm, kdoctools,
  lm_sensors,
  kconfig, kcoreaddons, kdelibs4support, ki18n, kiconthemes, kitemviews,
  knewstuff, libksysguard, qtwebkit
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [ ecm kdoctools ];
  buildInputs = [ lm_sensors ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n qtwebkit
  ];
}
