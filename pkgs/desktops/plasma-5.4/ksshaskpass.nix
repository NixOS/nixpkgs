{ plasmaPackage, extra-cmake-modules, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons, makeKDEWrapper
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
  buildInputs = [ kcoreaddons kwallet kwidgetsaddons ];
  propagatedBuildInputs = [ ki18n ];
  postInstall = ''
    wrapKDEProgram "$out/bin/ksshaskpass"
  '';
}
