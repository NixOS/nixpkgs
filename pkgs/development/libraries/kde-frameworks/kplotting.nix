{
  mkDerivation,
  extra-cmake-modules,
  qttools,
  qtbase,
}:

mkDerivation {
  pname = "kplotting";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    qtbase
    qttools
  ];
  outputs = [
    "out"
    "dev"
  ];
}
