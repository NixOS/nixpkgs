{ mkDerivation, lib, extra-cmake-modules, qtbase, qttools, gperf }:

mkDerivation {
  name = "kcodecs";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools gperf ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
