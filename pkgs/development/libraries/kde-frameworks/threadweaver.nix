{
  mkDerivation,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  name = "threadweaver";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
