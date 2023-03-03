{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qttools
}:

mkDerivation {
  pname = "kwidgetsaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
