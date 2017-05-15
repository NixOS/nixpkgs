{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools
}:

mkDerivation {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
}
