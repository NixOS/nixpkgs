{ plasmaPackage, ecm, kdoctools, kconfig
, kcoreaddons, kdelibs4support, ki18n, kitemviews, knewstuff
, kiconthemes, libksysguard
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n
  ];
}
