{ qtSubmodule, qtbase, qtquickcontrols, wayland, pkgconfig }:

qtSubmodule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
}
