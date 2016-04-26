{ kdeFramework, lib
, extra-cmake-modules
, kcodecs, kconfig, kcoreaddons, kwindowsystem
, libdbusmenu
, phonon
, qtx11extras
}:

kdeFramework {
  name = "knotifications";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcodecs kconfig kcoreaddons libdbusmenu phonon
  ];
  propagatedBuildInputs = [ kwindowsystem qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
