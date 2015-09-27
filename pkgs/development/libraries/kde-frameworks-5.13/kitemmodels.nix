{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "kitemmodels";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
