{ plasmaPackage, extra-cmake-modules, kdoctools, kdelibs4support
, qtx11extras
}:

plasmaPackage {
  name = "kgamma5";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kdelibs4support qtx11extras ];
}
