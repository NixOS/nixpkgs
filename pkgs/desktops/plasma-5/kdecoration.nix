{ mkDerivation, lib, extra-cmake-modules, qtbase, ki18n }:

mkDerivation {
  pname = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n ];
  outputs = [ "out" "dev" ];
}
