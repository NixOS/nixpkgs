{ plasmaPackage
, ecm
, kidletime
, kwayland
, kwindowsystem
}:

plasmaPackage {
  name = "kwayland-integration";
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    kidletime kwindowsystem kwayland
  ];
}
