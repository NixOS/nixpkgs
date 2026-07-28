{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  qttools,
  qtx11extras,
}:

mkDerivation {
  pname = "kdbusaddons";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    qttools
    qtx11extras
  ];
  propagatedBuildInputs = [ qtbase ];
}
