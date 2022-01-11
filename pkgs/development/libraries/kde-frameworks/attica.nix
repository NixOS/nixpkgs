{ mkDerivation, extra-cmake-modules, qtbase }:

mkDerivation {
  name = "attica";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
