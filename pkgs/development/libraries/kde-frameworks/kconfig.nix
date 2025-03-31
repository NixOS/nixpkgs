{
  mkDerivation,
  extra-cmake-modules,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
