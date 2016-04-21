{ kdeFramework, lib
, extra-cmake-modules
, modemmanager
}:

kdeFramework {
  name = "modemmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ modemmanager ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
