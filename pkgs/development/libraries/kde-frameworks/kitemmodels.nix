{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  name = "kitemmodels";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
