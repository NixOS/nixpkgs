{ mkDerivation, extra-cmake-modules, qtbase, qtquickcontrols2, qttranslations, qtgraphicaleffects }:

mkDerivation {
  name = "kirigami2";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase qtquickcontrols2 qttranslations qtgraphicaleffects ];
  outputs = [ "out" "dev" ];
}
