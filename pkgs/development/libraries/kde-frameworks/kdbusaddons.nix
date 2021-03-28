{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools, qtx11extras
}:

mkDerivation {
  name = "kdbusaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
