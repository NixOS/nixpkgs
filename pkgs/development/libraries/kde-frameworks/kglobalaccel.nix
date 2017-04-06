{
  kdeFramework, lib, extra-cmake-modules,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kservice, kwindowsystem,
  qtx11extras
}:

kdeFramework {
  name = "kglobalaccel";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kservice kwindowsystem qtx11extras
  ];
}
