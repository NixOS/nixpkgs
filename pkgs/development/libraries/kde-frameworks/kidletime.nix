{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qtx11extras
}:

mkDerivation {
  name = "kidletime";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
}
