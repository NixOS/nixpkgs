{ plasmaPackage, ecm, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons, makeQtWrapper
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons ];
  postInstall = ''
    wrapQtProgram "$out/bin/ksshaskpass"
  '';
}
