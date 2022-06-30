{ mkDerivation
, extra-cmake-modules
, qtbase, qtx11extras, wayland, plasma-wayland-protocols
}:

mkDerivation {
  pname = "kguiaddons";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras wayland plasma-wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [ "out" "dev" ];
}
