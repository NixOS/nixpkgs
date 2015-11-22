{ plasmaPackage
, extra-cmake-modules
}:

plasmaPackage {
  name = "plasma-workspace-wallpapers";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
