{ mkDerivation, extra-cmake-modules, qtbase, qtquickcontrols2, qtgraphicaleffects, qttools }:

mkDerivation {
  pname = "kirigami2";
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
  outputs = [ "out" "dev" ];
}
