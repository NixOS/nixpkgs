{ mkDerivation, lib
, extra-cmake-modules
, kcoreaddons
, kwindowsystem
, qtx11extras
}:

mkDerivation {
  name = "kcrash";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kwindowsystem qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
