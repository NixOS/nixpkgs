{ mkDerivation, lib, extra-cmake-modules, qtbase, kcoreaddons, ki18n }:

mkDerivation {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase kcoreaddons ki18n ];
  outputs = [ "out" "dev" ];
}
