{
  mkDerivation, lib,
  extra-cmake-modules,
  boost, kactivities, kconfig, qtbase,
}:

mkDerivation {
  name = "kactivities-stats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ boost kactivities kconfig ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
