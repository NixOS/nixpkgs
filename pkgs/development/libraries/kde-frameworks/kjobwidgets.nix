{
  mkDerivation,
  extra-cmake-modules, qttools,
  kcoreaddons, kwidgetsaddons, qtx11extras
}:

mkDerivation {
  name = "kjobwidgets";
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
}
