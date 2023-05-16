<<<<<<< HEAD
{ mkDerivation, extra-cmake-modules, qtbase, qtquickcontrols2, qtgraphicaleffects, qttools }:

mkDerivation {
  pname = "kirigami2";
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
=======
{ mkDerivation, extra-cmake-modules, qtbase, qtquickcontrols2, qttranslations, qtgraphicaleffects }:

mkDerivation {
  pname = "kirigami2";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase qtquickcontrols2 qttranslations qtgraphicaleffects ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  outputs = [ "out" "dev" ];
}
