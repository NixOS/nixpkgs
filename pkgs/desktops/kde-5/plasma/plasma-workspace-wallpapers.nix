{ plasmaPackage
, ecm
}:

plasmaPackage {
  name = "plasma-workspace-wallpapers";
  outputs = [ "out" ];
  nativeBuildInputs = [
    ecm
  ];
}
