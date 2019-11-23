{ mkDerivation, lib
, extra-cmake-modules, qttools, qtbase
}:

mkDerivation {
  name = "kplotting";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase qttools ];
  outputs = [ "out" "dev" ];
}
