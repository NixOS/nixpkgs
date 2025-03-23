{
  mkDerivation,
  extra-cmake-modules,
  qtbase,
  qttools,
  qtx11extras,
}:

mkDerivation {
  pname = "kdbusaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qttools
    qtx11extras
  ];
  propagatedBuildInputs = [ qtbase ];
}
