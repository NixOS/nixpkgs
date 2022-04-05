{ mkDerivation
, extra-cmake-modules
, kcodecs, kconfig, kcoreaddons, kwindowsystem
, libdbusmenu
, phonon
, qttools, qtx11extras
}:

mkDerivation {
  pname = "knotifications";
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    kcodecs kconfig kcoreaddons kwindowsystem libdbusmenu phonon qtx11extras
  ];
}
