{
  mkDerivation, lib,
  extra-cmake-modules,
  kguiaddons, kidletime, kwayland, kwindowsystem, qtbase,
  wayland-protocols, wayland-scanner, wayland
}:

mkDerivation {
  pname = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules wayland-scanner ];
  buildInputs = [ kguiaddons kidletime kwindowsystem kwayland qtbase wayland-protocols wayland ];
}
