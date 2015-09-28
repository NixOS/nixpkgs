{ mkDerivation, extra-cmake-modules }:

mkDerivation {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
}
