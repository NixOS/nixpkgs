{
  mkDerivation,
  extra-cmake-modules,
  modemmanager, qtbase
}:

mkDerivation {
  pname = "modemmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager qtbase ];
  outputs = [ "out" "dev" ];
}
