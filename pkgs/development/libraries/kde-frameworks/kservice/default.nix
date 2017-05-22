{
  mkDerivation, lib, copyPathsToStore,
  bison, extra-cmake-modules, flex,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem,
  qtbase,
}:

mkDerivation {
  name = "kservice";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedNativeBuildInputs = [ bison flex ];
  buildInputs = [
    kcrash kdbusaddons ki18n kwindowsystem qtbase
  ];
  propagatedBuildInputs = [ kconfig kcoreaddons ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
