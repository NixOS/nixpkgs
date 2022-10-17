{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qtx11extras,
  wayland, plasma-wayland-protocols
}:

mkDerivation {
  pname = "kidletime";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras wayland plasma-wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];
}
