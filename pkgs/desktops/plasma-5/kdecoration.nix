{ mkDerivation, extra-cmake-modules, qtbase, ki18n }:

mkDerivation {
  name = "kdecoration";
  meta = {
    broken = builtins.compareVersions qtbase.version "5.12.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n ];
  outputs = [ "out" "dev" ];
  broken = true;
}
