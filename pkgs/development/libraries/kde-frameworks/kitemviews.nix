{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

mkDerivation {
  name = "kitemviews";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
