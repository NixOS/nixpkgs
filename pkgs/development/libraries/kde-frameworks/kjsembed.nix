{
  mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kjs
, qtsvg
}:

mkDerivation {
  name = "kjsembed";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ ki18n kjs qtsvg ];
}
