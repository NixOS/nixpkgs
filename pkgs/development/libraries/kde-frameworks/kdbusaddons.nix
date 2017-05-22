{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools, qtx11extras
}:

mkDerivation {
  name = "kdbusaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
