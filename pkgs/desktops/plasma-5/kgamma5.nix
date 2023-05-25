{ mkDerivation
, extra-cmake-modules
, kdoctools
, kconfig
, kconfigwidgets
, ki18n
, qtx11extras
, libXxf86vm
}:

mkDerivation {
  pname = "kgamma5";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kconfig kconfigwidgets ki18n qtx11extras libXxf86vm ];
}
