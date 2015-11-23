{ plasmaPackage
, extra-cmake-modules
, libXrandr
, qtx11extras
}:

plasmaPackage {
  name = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libXrandr
  ];
  propagatedBuildInputs = [
    qtx11extras
  ];
}
