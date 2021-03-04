{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qtx11extras, wayland,
}:

mkDerivation {
  name = "kguiaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras wayland ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
