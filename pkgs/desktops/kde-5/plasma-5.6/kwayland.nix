{ plasmaPackage
, extra-cmake-modules
, wayland
}:

plasmaPackage {
  name = "kwayland";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    wayland
  ];
}
