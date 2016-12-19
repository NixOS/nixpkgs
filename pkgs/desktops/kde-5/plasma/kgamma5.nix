{ plasmaPackage, ecm, kdoctools, kdelibs4support
, qtx11extras
}:

plasmaPackage {
  name = "kgamma5";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ kdelibs4support qtx11extras ];
}
