{ plasmaPackage
, extra-cmake-modules
, kidletime
, kwayland
, kwindowsystem
}:

plasmaPackage {
  name = "kwayland-integration";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kidletime kwindowsystem kwayland
  ];
}
