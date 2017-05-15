{ mkDerivation, lib, extra-cmake-modules, kcoreaddons, ki18n }:

mkDerivation {
  name = "kpty";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n ];
}
