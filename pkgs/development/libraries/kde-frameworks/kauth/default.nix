{
  mkDerivation, propagate,
  extra-cmake-modules, kcoreaddons, polkit-qt, qttools
, enablePolkit ? true
}:

mkDerivation {
  name = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = (if enablePolkit then [ polkit-qt ] else []) ++ [ qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [
    ./cmake-install-paths.patch
  ];
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [ "out" "dev" ];
  setupHook = propagate "out";
}
