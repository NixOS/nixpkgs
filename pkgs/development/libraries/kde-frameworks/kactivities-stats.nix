{ mkDerivation, lib, extra-cmake-modules, boost, kactivities, kconfig }:

mkDerivation {
  name = "kactivities-stats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ boost kactivities kconfig ];
}
