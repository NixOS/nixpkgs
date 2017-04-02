{
  kdeFramework, lib, extra-cmake-modules,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdoctools, kinit, kservice
}:

kdeFramework {
  name = "kded";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kinit kservice
  ];
}
