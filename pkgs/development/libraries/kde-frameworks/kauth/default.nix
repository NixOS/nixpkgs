{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules, kcoreaddons, polkit-qt, qttools }:

kdeFramework {
  name = "kauth";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ kcoreaddons polkit-qt ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
