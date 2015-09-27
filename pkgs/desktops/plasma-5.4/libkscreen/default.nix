{ mkDerivation
, extra-cmake-modules
, libXrandr
, qtx11extras
}:

mkDerivation {
  name = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libXrandr
    qtx11extras
  ];
}
