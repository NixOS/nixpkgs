{ mkDerivation, extra-cmake-modules, qtbase, qtquickcontrols2, qttranslations }:

mkDerivation {
  name = "kirigami2";
  meta = {
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase qtquickcontrols2 qttranslations ];
  outputs = [ "out" "dev" ];
}
