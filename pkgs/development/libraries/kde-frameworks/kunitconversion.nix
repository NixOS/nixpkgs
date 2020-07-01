{ mkDerivation, lib, extra-cmake-modules, ki18n, qtbase, }:

mkDerivation {
  name = "kunitconversion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
