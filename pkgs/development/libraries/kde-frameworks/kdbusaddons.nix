{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qttools, qtx11extras
}:

mkDerivation {
  name = "kdbusaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
