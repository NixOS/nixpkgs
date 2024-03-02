{ mkDerivation
, extra-cmake-modules
, kconfig
, kconfigwidgets
, kdoctools
, kguiaddons
, kiconthemes
, kirigami2
, qtquickcontrols2
, qtx11extras
}:

mkDerivation {
  pname = "qqc2-breeze-style";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig
    kconfigwidgets
    kguiaddons
    kiconthemes
    kirigami2
    qtquickcontrols2
    qtx11extras
  ];
}
