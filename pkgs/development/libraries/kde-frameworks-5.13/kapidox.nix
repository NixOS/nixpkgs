{ mkDerivation, lib
, extra-cmake-modules
, python
}:

mkDerivation {
  name = "kapidox";
  nativeBuildInputs = [ extra-cmake-modules python ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
