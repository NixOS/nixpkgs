{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, kwindowsystem
, qtx11extras
}:

kdeFramework {
  name = "kcrash";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ];
  propagatedBuildInputs = [ kwindowsystem qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
