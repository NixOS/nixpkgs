{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "karchive";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
