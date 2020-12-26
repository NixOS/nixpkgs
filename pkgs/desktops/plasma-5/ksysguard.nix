{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  libcap, libpcap, libnl, lm_sensors, networkmanager-qt,
  kconfig, kcoreaddons, kdelibs4support, ki18n, kiconthemes, kitemviews,
  knewstuff, libksysguard, qtbase,
}:

mkDerivation {
  name = "ksysguard";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n libcap libpcap libnl lm_sensors networkmanager-qt
  ];
}
