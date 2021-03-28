{
  mkDerivation, lib,
  extra-cmake-modules,
  networkmanager, qtbase,
}:

mkDerivation {
  name = "networkmanager-qt";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager qtbase ];
  outputs = [ "out" "dev" ];
}
