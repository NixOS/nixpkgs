{
  mkDerivation,
  extra-cmake-modules,
  kcoreaddons, kwindowsystem, qtbase, qtx11extras,
}:

mkDerivation {
  name = "kcrash";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kwindowsystem qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
