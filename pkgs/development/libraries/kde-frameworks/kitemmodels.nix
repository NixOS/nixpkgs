{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  name = "kitemmodels";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.14.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
