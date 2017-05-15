{ mkDerivation, lib, extra-cmake-modules, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, qtbase, solid
}:

mkDerivation {
  name = "baloo";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kauth kconfig kcoreaddons kcrash kdbusaddons kfilemetadata ki18n kio
    kidletime lmdb qtbase solid
  ];
}
