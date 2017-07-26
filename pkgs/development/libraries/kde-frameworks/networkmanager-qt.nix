{
  mkDerivation, lib,
  extra-cmake-modules,
  networkmanager, qtbase,
}:

mkDerivation {
  name = "networkmanager-qt";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager qtbase ];
  outputs = [ "out" "dev" ];
}
