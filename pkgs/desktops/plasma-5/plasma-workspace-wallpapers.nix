{ plasmaPackage
, extra-cmake-modules
}:

plasmaPackage {
  name = "plasma-workspace-wallpapers";
  outputs = [ "out" ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
