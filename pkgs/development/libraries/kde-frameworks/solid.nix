{
  mkDerivation, lib,
  bison, extra-cmake-modules, flex,
  media-player-info, qtbase, qtdeclarative, qttools
}:

mkDerivation {
  name = "solid";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.14.0" < 0;
  };
  nativeBuildInputs = [ bison extra-cmake-modules flex media-player-info ];
  buildInputs = [ qtdeclarative qttools ];
  propagatedBuildInputs = [ qtbase ];
  propagatedUserEnvPkgs = [ media-player-info ];
}
