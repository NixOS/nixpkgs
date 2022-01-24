{ mkDerivation, extra-cmake-modules, qtbase, qttools, gperf }:

mkDerivation {
  name = "kcodecs";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools gperf ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
