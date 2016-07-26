{ kdeFramework, lib
, extra-cmake-modules
, qtx11extras
}:

kdeFramework {
  name = "kdbusaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtx11extras ];
}
