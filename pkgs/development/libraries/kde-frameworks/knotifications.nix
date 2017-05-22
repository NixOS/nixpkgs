{ mkDerivation, lib
, extra-cmake-modules
, kcodecs, kconfig, kcoreaddons, kwindowsystem
, libdbusmenu
, phonon
, qttools, qtx11extras
}:

mkDerivation {
  name = "knotifications";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    kcodecs kconfig kcoreaddons kwindowsystem libdbusmenu phonon qtx11extras
  ];
}
