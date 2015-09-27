{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "threadweaver";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
