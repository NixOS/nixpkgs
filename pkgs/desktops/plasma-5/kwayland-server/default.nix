{
  mkDerivation, cmake,
  extra-cmake-modules, kdoctools,
  kwayland, plasma-wayland-protocols,
  wayland, wayland-protocols
}:

mkDerivation {
  name = "kwayland-server";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules #kdoctools
  ];
  buildInputs = [
    kwayland plasma-wayland-protocols wayland wayland-protocols
  ];
  patches = [ ./0001-Use-KDE_INSTALL_TARGETS_DEFAULT_ARGS-when-installing.patch ];
}
