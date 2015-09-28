{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "attica";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
