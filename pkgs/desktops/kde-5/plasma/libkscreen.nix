{ plasmaPackage
, ecm
, kwayland, libXrandr
, qtx11extras
}:

plasmaPackage {
  name = "libkscreen";
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    kwayland libXrandr qtx11extras
  ];
}
