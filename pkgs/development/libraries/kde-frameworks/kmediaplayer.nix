{ mkDerivation
, extra-cmake-modules
, kparts
, kxmlgui
}:

mkDerivation {
  name = "kmediaplayer";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kparts kxmlgui ];
}
