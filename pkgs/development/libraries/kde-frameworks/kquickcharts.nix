{
  mkDerivation, lib,
  extra-cmake-modules,
  qtquickcontrols2, qtbase,
}:

mkDerivation {
  name = "kquickcharts";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtquickcontrols2 ];
  outputs = [ "out" "dev" ];
}
