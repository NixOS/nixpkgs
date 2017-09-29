{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, ki18n, qtx11extras,
}:

mkDerivation {
  name = "kgamma5";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kconfig kconfigwidgets ki18n qtx11extras ];
}
