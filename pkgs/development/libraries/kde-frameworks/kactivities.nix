{
  mkDerivation,
  extra-cmake-modules,
  boost, kconfig, kcoreaddons, kio, kwindowsystem, qtbase, qtdeclarative,
}:

mkDerivation {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kconfig kcoreaddons kio kwindowsystem qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
