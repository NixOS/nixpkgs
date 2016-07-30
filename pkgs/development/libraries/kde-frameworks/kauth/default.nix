{ kdeFramework, lib, copyPathsToStore, ecm, kcoreaddons, polkit-qt }:

kdeFramework {
  name = "kauth";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons polkit-qt ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
