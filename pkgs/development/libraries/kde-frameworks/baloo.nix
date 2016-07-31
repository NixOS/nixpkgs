{ kdeFramework, lib, ecm, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, qtbase, solid
}:

kdeFramework {
  name = "baloo";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kauth kconfig kcoreaddons kcrash kdbusaddons kfilemetadata ki18n kio
    kidletime lmdb qtbase solid
  ];
}
