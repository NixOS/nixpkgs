{ kdeFramework, lib
, extra-cmake-modules
, qtx11extras
}:

kdeFramework {
  name = "kguiaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtx11extras ];
}
