{
  mkDerivation, lib, propagateBin,
  extra-cmake-modules,
  qtbase, wayland
}:

mkDerivation {
  name = "kwayland";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ wayland ];
  propagatedBuildInputs = [ qtbase ];
  setupHook = propagateBin; # XDG_CONFIG_DIRS
}
