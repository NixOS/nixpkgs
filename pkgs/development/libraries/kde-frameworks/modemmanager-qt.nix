{ kdeFramework, lib
, extra-cmake-modules
, modemmanager, qtbase
}:

kdeFramework {
  name = "modemmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ modemmanager ];
}
