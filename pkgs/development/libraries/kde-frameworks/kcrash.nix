{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, kwindowsystem, qtx11extras }:

kdeFramework {
  name = "kcrash";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons kwindowsystem qtx11extras ];
}
