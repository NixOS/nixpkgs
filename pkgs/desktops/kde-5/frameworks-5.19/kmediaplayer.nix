{ kdeFramework, lib
, extra-cmake-modules
, kparts
, kxmlgui
}:

kdeFramework {
  name = "kmediaplayer";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kxmlgui ];
  propagatedBuildInputs = [ kparts ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
