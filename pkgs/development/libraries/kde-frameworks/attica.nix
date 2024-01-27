{ mkDerivation, extra-cmake-modules, qtbase }:

mkDerivation {
  pname = "attica";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
