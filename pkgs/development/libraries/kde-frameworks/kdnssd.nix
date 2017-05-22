{
  mkDerivation, lib,
  extra-cmake-modules,
  avahi, qtbase, qttools,
}:

mkDerivation {
  name = "kdnssd";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ avahi qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
