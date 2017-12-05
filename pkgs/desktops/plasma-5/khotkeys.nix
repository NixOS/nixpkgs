{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcmutils, kdbusaddons, kdelibs4support, kglobalaccel, ki18n, kio, kxmlgui,
  plasma-framework, plasma-workspace, qtx11extras
}:

mkDerivation {
  name = "khotkeys";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kdbusaddons kdelibs4support kglobalaccel ki18n kio kxmlgui
    plasma-framework plasma-workspace qtx11extras
  ];
  outputs = [ "out" "dev" "bin" ];
  enableParallelBuilding = false;
}
