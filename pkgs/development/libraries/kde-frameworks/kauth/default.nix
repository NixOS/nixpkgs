{
  mkDerivation, propagate,
  extra-cmake-modules, kcoreaddons, polkit-qt, qttools
}:

mkDerivation {
  name = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ polkit-qt qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [
    ./cmake-install-paths.patch
  ];
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [ "out" "dev" ];
  setupHook = propagate "out";
}
