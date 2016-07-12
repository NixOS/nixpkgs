{ kdeFramework, lib
, extra-cmake-modules
, modemmanager
}:

kdeFramework {
  name = "modemmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager ];
}
