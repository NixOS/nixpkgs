{ qtSubmodule, qtbase, wayland, libxkbcommon, pkgconfig }:

qtSubmodule {
  name = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland libxkbcommon pkgconfig ];
}
