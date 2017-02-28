{ kdeFramework
, extra-cmake-modules
, qtbase, wayland
}:

kdeFramework {
  name = "kwayland";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [
    wayland
  ];
}
