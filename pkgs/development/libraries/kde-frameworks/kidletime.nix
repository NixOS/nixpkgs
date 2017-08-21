{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qtx11extras
}:

mkDerivation {
  name = "kidletime";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
