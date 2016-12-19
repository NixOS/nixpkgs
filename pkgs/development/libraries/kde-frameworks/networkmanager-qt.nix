{ kdeFramework, lib
, ecm
, networkmanager
}:

kdeFramework {
  name = "networkmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ networkmanager ];
}
