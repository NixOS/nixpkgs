{ mkDerivation , extra-cmake-modules }:

mkDerivation {
  name = "plasma-workspace-wallpapers";
  nativeBuildInputs = [ extra-cmake-modules ];
}
