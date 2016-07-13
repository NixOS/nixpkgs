{ plasmaPackage, extra-cmake-modules, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons, makeQtWrapper
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons ];
  postInstall = ''
    wrapQtProgram "$out/bin/ksshaskpass"
  '';
}
