{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "kcodecs";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
