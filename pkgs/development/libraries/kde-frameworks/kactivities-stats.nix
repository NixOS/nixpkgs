{ kdeFramework, lib, ecm, boost, kactivities, kconfig }:

kdeFramework {
  name = "kactivities-stats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ boost kactivities kconfig ];
}
