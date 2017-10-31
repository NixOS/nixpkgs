{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcoreaddons, ki18n, kwallet, kwidgetsaddons, qtbase,
}:

mkDerivation {
  name = "ksshaskpass";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons ki18n kwallet kwidgetsaddons qtbase ];
}
