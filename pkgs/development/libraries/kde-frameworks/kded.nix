{
  kdeFramework, lib, ecm,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdoctools, kinit, kservice
}:

kdeFramework {
  name = "kded";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kinit kservice
  ];
}
