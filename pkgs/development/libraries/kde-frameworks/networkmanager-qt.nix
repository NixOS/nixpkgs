{
  mkDerivation,
  extra-cmake-modules,
  networkmanager, qtbase,
}:

mkDerivation {
  name = "networkmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager qtbase ];
  outputs = [ "out" "dev" ];
}
