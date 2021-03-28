{ mkDerivation, lib
, extra-cmake-modules, qttools, qtbase
}:

mkDerivation {
  name = "kplotting";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase qttools ];
  outputs = [ "out" "dev" ];
}
