{ plasmaPackage, extra-cmake-modules, kdoctools, kconfig
, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils, kdelibs4support
, khtml, kservice, makeQtWrapper
}:

plasmaPackage {
  name = "khelpcenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kdelibs4support khtml ki18n kconfig kcoreaddons kdbusaddons kinit kcmutils
    kservice
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/khelpcenter"
  '';
}
