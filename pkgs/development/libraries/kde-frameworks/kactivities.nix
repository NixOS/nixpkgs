{
  mkDerivation, lib,
  extra-cmake-modules,
  boost, kconfig, kcoreaddons, kio, kwindowsystem, qtbase, qtdeclarative,
}:

mkDerivation {
  name = "kactivities";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kconfig kcoreaddons kio kwindowsystem qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
