{ mkDerivation, lib, extra-cmake-modules, kcoreaddons, ki18n, qtbase, }:

mkDerivation {
  name = "kpty";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
