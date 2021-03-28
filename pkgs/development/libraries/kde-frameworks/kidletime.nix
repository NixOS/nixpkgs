{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qtx11extras
}:

mkDerivation {
  name = "kidletime";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
