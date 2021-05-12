{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  libcap, libpcap, lm_sensors,
  kconfig, kcoreaddons, ki18n, kiconthemes, kinit, kitemviews,
  knewstuff, libksysguard, qtbase,
  networkmanager-qt, libnl
}:

mkDerivation {
  name = "ksysguard";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kitemviews kinit kiconthemes knewstuff libksysguard
    ki18n libcap libpcap lm_sensors networkmanager-qt libnl
  ];
}
