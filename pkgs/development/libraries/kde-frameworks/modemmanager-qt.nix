{
  mkDerivation,
  extra-cmake-modules,
  modemmanager, qtbase
}:

mkDerivation {
  name = "modemmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager qtbase ];
  outputs = [ "out" "dev" ];
}
