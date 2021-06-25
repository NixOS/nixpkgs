{ mkDerivation
, extra-cmake-modules, qttools, qtbase
}:

mkDerivation {
  name = "kplotting";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase qttools ];
  outputs = [ "out" "dev" ];
}
