{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qttools
}:

mkDerivation {
  name = "kwidgetsaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
