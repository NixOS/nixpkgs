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
  buildInputs = [
    kwayland libXrandr
  ];
  propagatedBuildInputs = [
    qtx11extras
  ];
}
