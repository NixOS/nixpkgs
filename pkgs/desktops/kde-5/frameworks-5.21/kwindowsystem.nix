{ kdeFramework, lib
, extra-cmake-modules
, qtx11extras
}:

kdeFramework {
  name = "kwindowsystem";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
