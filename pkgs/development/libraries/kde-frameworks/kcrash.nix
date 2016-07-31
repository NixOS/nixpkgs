{ kdeFramework, lib, ecm, kcoreaddons, kwindowsystem, qtx11extras }:

kdeFramework {
  name = "kcrash";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons kwindowsystem qtx11extras ];
}
