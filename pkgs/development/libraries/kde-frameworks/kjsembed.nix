{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, qttools,
  ki18n, kjs, qtsvg,
}:

mkDerivation {
  name = "kjsembed";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools qttools ];
  buildInputs = [ ki18n qtsvg ];
  propagatedBuildInputs = [ kjs ];
}
