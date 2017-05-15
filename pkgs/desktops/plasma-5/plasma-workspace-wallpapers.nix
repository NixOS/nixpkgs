{ mkDerivation
, extra-cmake-modules
}:

mkDerivation {
  name = "plasma-workspace-wallpapers";
  outputs = [ "out" ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
