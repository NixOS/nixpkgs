{
  mkDerivation, lib, propagate,
  extra-cmake-modules, kdoctools,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kinit, kservice, qtbase,
}:

mkDerivation {
  name = "kded";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kinit kservice qtbase
  ];
  outputs = [ "out" "dev" ];
  setupHook = propagate "out";
}
