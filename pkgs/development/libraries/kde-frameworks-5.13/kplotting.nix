{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "kplotting";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
