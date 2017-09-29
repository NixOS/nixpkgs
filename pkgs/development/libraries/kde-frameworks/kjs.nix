{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  pcre, qtbase,
}:

mkDerivation {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ pcre qtbase ];
}
