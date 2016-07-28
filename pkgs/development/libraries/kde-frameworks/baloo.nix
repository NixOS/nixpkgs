{ kdeFramework, lib, extra-cmake-modules, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, qtbase, solid
}:

kdeFramework {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kauth kconfig kcoreaddons kcrash kdbusaddons kfilemetadata ki18n kio
    kidletime lmdb qtbase solid
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
