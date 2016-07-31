{ kdeFramework, lib
, ecm
, modemmanager
}:

kdeFramework {
  name = "modemmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ modemmanager ];
}
