{ mkDerivation, extra-cmake-modules, kdoctools, kcoreaddons
, ki18n, kwallet, kwidgetsaddons
}:

mkDerivation {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons ];
}
