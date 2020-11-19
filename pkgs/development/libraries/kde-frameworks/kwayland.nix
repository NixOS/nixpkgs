{
  mkDerivation, lib, propagateBin,
  extra-cmake-modules,
  plasma-wayland-protocols, qtbase, wayland, wayland-protocols
}:

mkDerivation {
  name = "kwayland";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plasma-wayland-protocols wayland wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];
  setupHook = propagateBin; # XDG_CONFIG_DIRS
}
