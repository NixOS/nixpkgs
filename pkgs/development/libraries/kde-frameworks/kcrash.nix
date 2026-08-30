{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kcoreaddons,
  kwindowsystem,
  qtbase,
  qtx11extras,
}:

mkDerivation {
  pname = "kcrash";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    kcoreaddons
    kwindowsystem
    qtx11extras
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
