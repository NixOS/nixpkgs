{ plasmaPackage
, extra-cmake-modules
, kdoctools
, kdelibs4support
, qtx11extras
}:

plasmaPackage {
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
