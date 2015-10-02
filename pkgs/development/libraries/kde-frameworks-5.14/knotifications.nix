{ kdeFramework, lib
, extra-cmake-modules
, kcodecs
, kconfig
, kcoreaddons
, kwindowsystem
, phonon
, qtx11extras
}:

kdeFramework {
  name = "knotifications";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcodecs kconfig kcoreaddons kwindowsystem
    phonon qtx11extras
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
