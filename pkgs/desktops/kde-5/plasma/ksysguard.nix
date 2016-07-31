{ plasmaPackage, ecm, kdoctools, kconfig
, kcoreaddons, kdelibs4support, ki18n, kitemviews, knewstuff
, kiconthemes, libksysguard, makeQtWrapper
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [
    ecm
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
    kdelibs4support ki18n
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/ksysguardd"
  '';
}
