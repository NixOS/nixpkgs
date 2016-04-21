{ kdeFramework, lib, extra-cmake-modules
, boost, kactivities, kconfig }:

kdeFramework {
  name = "kactivities-stats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ boost kactivities kconfig ];
}
