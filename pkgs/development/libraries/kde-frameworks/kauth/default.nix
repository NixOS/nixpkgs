{
  mkDerivation, lib, copyPathsToStore, propagate,
  extra-cmake-modules, kcoreaddons, polkit-qt, qttools
}:

mkDerivation {
  name = "kauth";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ polkit-qt qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [ "out" "dev" ];
  setupHook = propagate "out";
}
