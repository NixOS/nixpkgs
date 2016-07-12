{ plasmaPackage
, extra-cmake-modules
, kwayland, libXrandr
, qtx11extras
}:

plasmaPackage {
  name = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kwayland libXrandr qtx11extras
  ];
}
