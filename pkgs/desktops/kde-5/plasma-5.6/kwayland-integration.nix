{ plasmaPackage
, extra-cmake-modules
, wayland
, kwayland
, kidletime
, kwindowsystem
}:

plasmaPackage {
  name = "kwayland-integration";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    wayland kwayland kidletime kwindowsystem
  ];
}
