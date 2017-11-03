{ mkDerivation, extra-cmake-modules, qtbase }:

mkDerivation {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
