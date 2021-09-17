{
  mkDerivation,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  name = "kitemmodels";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
