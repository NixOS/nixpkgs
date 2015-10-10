{ plasmaPackage, extra-cmake-modules, kdoctools, kconfig
, kcoreaddons, kdelibs4support, ki18n, kitemviews, knewstuff
, kiconthemes, libksysguard
}:

plasmaPackage {
  name = "ksysguard";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig kcoreaddons kitemviews knewstuff kiconthemes libksysguard
  ];
  propagatedBuildInputs = [ kdelibs4support ki18n ];
  postInstall = ''
    wrapKDEProgram "$out/bin/ksysguardd"
    wrapKDEProgram "$out/bin/ksysguard"
  '';
}
