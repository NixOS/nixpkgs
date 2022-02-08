{ mkDerivation, lib, extra-cmake-modules, qtbase, ki18n, kcoreaddons }:

mkDerivation {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n kcoreaddons ];
  outputs = [ "out" "dev" ];
}
