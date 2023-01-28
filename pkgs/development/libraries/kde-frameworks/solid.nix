{
  mkDerivation,
  bison, extra-cmake-modules, flex,
  media-player-info, qtbase, qtdeclarative, qttools
}:

mkDerivation {
  pname = "solid";
  nativeBuildInputs = [ bison extra-cmake-modules flex media-player-info ];
  buildInputs = [ qtdeclarative qttools ];
  propagatedBuildInputs = [ qtbase ];
  propagatedUserEnvPkgs = [ media-player-info ];
}
