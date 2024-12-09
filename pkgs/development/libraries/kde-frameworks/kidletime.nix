{ mkDerivation
, extra-cmake-modules, wayland-scanner
, qtbase, qtx11extras
, wayland, wayland-protocols, plasma-wayland-protocols
}:

mkDerivation {
  pname = "kidletime";
  nativeBuildInputs = [ extra-cmake-modules wayland-scanner ];
  buildInputs = [ qtx11extras wayland wayland-protocols plasma-wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];
}
