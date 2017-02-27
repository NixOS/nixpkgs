{
  kdeFramework, lib, copyPathsToStore,
  bison, extra-cmake-modules, flex,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  propagatedNativeBuildInputs = [ bison extra-cmake-modules flex ];
  nativeBuildInputs = [ kdoctools ];
  propagatedBuildInputs = [ kconfig kcoreaddons kcrash kdbusaddons ki18n kwindowsystem ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
