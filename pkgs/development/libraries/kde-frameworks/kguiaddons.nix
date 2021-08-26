{ mkDerivation
, extra-cmake-modules
, qtbase, qtx11extras, wayland
}:

mkDerivation {
  name = "kguiaddons";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras wayland ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [ "out" "dev" ];
}
