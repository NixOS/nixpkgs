{
  mkDerivation,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  pname = "kitemmodels";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
