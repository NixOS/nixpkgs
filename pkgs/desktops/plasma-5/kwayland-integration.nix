{
  mkDerivation, lib,
  extra-cmake-modules,
  kguiaddons, kidletime, kwayland, kwindowsystem, qtbase,
}:

mkDerivation {
  name = "kwayland-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kguiaddons kidletime kwindowsystem kwayland qtbase ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
