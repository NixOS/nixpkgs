{
  mkDerivation, propagateBin, lib,
  extra-cmake-modules,
  plasma-wayland-protocols, qtbase, wayland, wayland-protocols
}:

mkDerivation {
  pname = "kwayland";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plasma-wayland-protocols wayland wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];
  setupHook = propagateBin; # XDG_CONFIG_DIRS
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
