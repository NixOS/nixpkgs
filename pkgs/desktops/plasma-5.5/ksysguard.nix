{ plasmaPackage, extra-cmake-modules, kdoctools, kconfig
, kcoreaddons, kdelibs4support, ki18n, kitemviews, knewstuff
, kiconthemes, libksysguard, makeQtWrapper
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
  ];
  propagatedBuildInputs = [ kdelibs4support ki18n ];
  postInstall = ''
    wrapQtProgram "$out/bin/ksysguardd"
  '';
}
