{ mkDerivation, lib, extra-cmake-modules, qtbase, qttools, gperf }:

mkDerivation {
  name = "kcodecs";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools gperf ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
