{ plasmaPackage, extra-cmake-modules, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons ];
}
