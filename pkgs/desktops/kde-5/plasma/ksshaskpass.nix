{ plasmaPackage, ecm, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons ];
}
