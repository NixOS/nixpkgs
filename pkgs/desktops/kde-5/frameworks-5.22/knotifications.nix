{ kdeFramework, lib
, extra-cmake-modules
, kcodecs, kconfig, kcoreaddons, kwindowsystem
, libdbusmenu
, phonon
, qtx11extras
}:

kdeFramework {
  name = "knotifications";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcodecs kconfig kcoreaddons kwindowsystem libdbusmenu phonon qtx11extras
  ];
}
