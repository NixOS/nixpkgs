{
  mkDerivation,
  extra-cmake-modules, kdoctools, qttools,
  ki18n, kjs, qtsvg,
}:

mkDerivation {
  pname = "kjsembed";
  nativeBuildInputs = [ extra-cmake-modules kdoctools qttools ];
  buildInputs = [ ki18n qtsvg ];
  propagatedBuildInputs = [ kjs ];
}
