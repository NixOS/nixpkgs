{
  mkDerivation,
  extra-cmake-modules,
  qttools,
  kcoreaddons,
  kwidgetsaddons,
  qtx11extras,
}:

mkDerivation {
  pname = "kjobwidgets";
  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];
  buildInputs = [
    kcoreaddons
    kwidgetsaddons
    qtx11extras
  ];
}
