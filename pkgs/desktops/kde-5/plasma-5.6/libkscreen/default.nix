{ plasmaPackage
, extra-cmake-modules
, libXrandr
, qtx11extras
, kwayland
}:

plasmaPackage {
  name = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libXrandr
    kwayland
  ];
  propagatedBuildInputs = [
    qtx11extras
  ];
}
