{ kdeFramework, lib
, extra-cmake-modules
, kparts
, kxmlgui
}:

kdeFramework {
  name = "kmediaplayer";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kparts kxmlgui ];
}
