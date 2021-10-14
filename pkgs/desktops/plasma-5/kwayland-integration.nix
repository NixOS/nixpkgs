{
  mkDerivation, lib,
  extra-cmake-modules,
  kguiaddons, kidletime, kwayland, kwindowsystem, qtbase,
  wayland, wayland-protocols
}:

mkDerivation {
  name = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kguiaddons kidletime kwindowsystem kwayland qtbase
    wayland wayland-protocols
  ];
}
