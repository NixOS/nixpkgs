{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kdoctools
, kinit
, kservice
}:

kdeFramework {
  name = "kded";
  buildInputs = [ kconfig kcoreaddons kcrash kdbusaddons kinit kservice ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
