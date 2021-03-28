{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

mkDerivation {
  name = "kwidgetsaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
