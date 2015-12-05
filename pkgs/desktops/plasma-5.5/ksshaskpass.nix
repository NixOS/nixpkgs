{ plasmaPackage, extra-cmake-modules, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons, makeQtWrapper
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [ kcoreaddons kwallet kwidgetsaddons ];
  propagatedBuildInputs = [ ki18n ];
  postInstall = ''
    wrapQtProgram "$out/bin/ksshaskpass"
  '';
}
