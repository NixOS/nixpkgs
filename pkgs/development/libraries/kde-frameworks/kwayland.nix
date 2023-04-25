{ mkDerivation, propagateBin
, extra-cmake-modules, wayland-scanner
, plasma-wayland-protocols, qtbase, wayland, wayland-protocols
}:

mkDerivation {
  pname = "kwayland";
  nativeBuildInputs = [ extra-cmake-modules wayland-scanner ];
  buildInputs = [ plasma-wayland-protocols wayland wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];
  setupHook = propagateBin; # XDG_CONFIG_DIRS
}
