{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules, kconfig, kcoreaddons
, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem
}:

kdeFramework {
  name = "kservice";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  propagatedNativeBuildInputs = [ extra-cmake-modules ];
  nativeBuildInputs = [ kdoctools ];
  propagatedBuildInputs = [ kconfig kcoreaddons kcrash kdbusaddons ki18n kwindowsystem ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
