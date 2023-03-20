{
  mkDerivation,
  extra-cmake-modules,
  networkmanager, qtbase,
}:

mkDerivation {
  pname = "networkmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager qtbase ];
  outputs = [ "out" "dev" ];
}
