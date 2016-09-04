{ kdeFramework, lib
, ecm
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kwindowsystem
, qtx11extras
}:

kdeFramework {
  name = "kglobalaccel";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kwindowsystem qtx11extras
  ];
}
