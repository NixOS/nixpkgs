{ mkDerivation, extra-cmake-modules }:

mkDerivation {
  pname = "plasma-workspace-wallpapers";
  nativeBuildInputs = [ extra-cmake-modules ];
}
