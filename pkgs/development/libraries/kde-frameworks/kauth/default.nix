{
  lib,
  stdenv,
  mkDerivation,
  propagate,
  cmake,
  extra-cmake-modules,
  kcoreaddons,
  qttools,
  enablePolkit ? stdenv.hostPlatform.isLinux,
  polkit-qt,
}:

mkDerivation {
  pname = "kauth";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = lib.optional enablePolkit polkit-qt ++ [ qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [
    ./cmake-install-paths.patch
  ];
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [
    "out"
    "dev"
  ];
  setupHook = propagate "out";
}
