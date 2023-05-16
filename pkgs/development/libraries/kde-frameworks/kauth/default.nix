{
<<<<<<< HEAD
  lib, stdenv, mkDerivation, propagate,
  extra-cmake-modules, kcoreaddons, qttools,
  enablePolkit ? stdenv.isLinux, polkit-qt
=======
  lib, mkDerivation, propagate,
  extra-cmake-modules, kcoreaddons, qttools,
  enablePolkit ? true, polkit-qt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = lib.optional enablePolkit polkit-qt ++ [ qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [
    ./cmake-install-paths.patch
  ];
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [ "out" "dev" ];
  setupHook = propagate "out";
}
