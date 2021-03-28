{ mkDerivation, lib, extra-cmake-modules, qtbase }:

mkDerivation {
  name = "attica";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
