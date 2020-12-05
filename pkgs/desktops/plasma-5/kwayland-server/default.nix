{
  mkDerivation, lib, cmake,
  extra-cmake-modules, kdoctools,
  kwayland, plasma-wayland-protocols,
  wayland, wayland-protocols, qtbase
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
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
