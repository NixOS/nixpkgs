{ plasmaPackage
, ecm
}:

plasmaPackage {
  name = "plasma-workspace-wallpapers";
  nativeBuildInputs = [
    ecm
  ];
}
