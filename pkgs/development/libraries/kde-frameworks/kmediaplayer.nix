{ kdeFramework, lib
, ecm
, kparts
, kxmlgui
}:

kdeFramework {
  name = "kmediaplayer";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kparts kxmlgui ];
}
