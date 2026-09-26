{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  boost,
  kconfig,
  kcoreaddons,
  kio,
  kwindowsystem,
  qtbase,
  qtdeclarative,
}:

mkDerivation {
  pname = "kactivities";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    boost
    kconfig
    kcoreaddons
    kio
    kwindowsystem
    qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
