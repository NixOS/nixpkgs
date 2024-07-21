{ mkDerivation
, extra-cmake-modules
, kparts
, kxmlgui
}:

mkDerivation {
  pname = "kmediaplayer";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kparts kxmlgui ];
}
