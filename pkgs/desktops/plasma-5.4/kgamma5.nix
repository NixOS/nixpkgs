{ mkDerivation
, extra-cmake-modules
, kdoctools
, kdelibs4support
, qtx11extras
}:

mkDerivation {
  name = "kgamma5";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kdelibs4support
    qtx11extras
  ];
}
