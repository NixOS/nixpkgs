{ mkDerivation, lib
, extra-cmake-modules
, kparts
, kxmlgui
}:

mkDerivation {
  name = "kmediaplayer";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kxmlgui ];
  propagatedBuildInputs = [ kparts ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
