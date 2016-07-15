{ kdeFramework
, extra-cmake-modules
, wayland
}:

kdeFramework {
  name = "kwayland";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    wayland
  ];
}
