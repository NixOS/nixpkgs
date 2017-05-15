{ mkDerivation, lib, extra-cmake-modules, ki18n }:

mkDerivation {
  name = "kunitconversion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ ki18n ];
}
