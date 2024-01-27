{
  mkDerivation,
  extra-cmake-modules,
  qtbase
}:

mkDerivation {
  pname = "threadweaver";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
