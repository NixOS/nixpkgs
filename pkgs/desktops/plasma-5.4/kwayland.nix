{ mkDerivation
, extra-cmake-modules
, wayland
}:

mkDerivation {
  name = "kwayland";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    wayland
  ];
}
