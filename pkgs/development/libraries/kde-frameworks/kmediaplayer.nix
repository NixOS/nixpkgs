{ mkDerivation, lib
, extra-cmake-modules
, kparts
, kxmlgui
}:

mkDerivation {
  name = "kmediaplayer";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kparts kxmlgui ];
}
