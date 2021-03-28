{
  mkDerivation, lib,
  extra-cmake-modules,
  modemmanager, qtbase
}:

mkDerivation {
  name = "modemmanager-qt";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager qtbase ];
  outputs = [ "out" "dev" ];
}
